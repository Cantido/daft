defmodule Daft.MIDI do
  alias Daft.MIDI.Header
  alias Daft.MIDI.Track
  alias Daft.MIDI.Message

  @enforce_keys [:header, :tracks]
  defstruct [:header, :tracks]

  def parse("MThd" <> <<_length::integer-size(32), format::integer-size(16), track_count::integer-size(16), division::integer-size(16), rest::binary>>) do
    %__MODULE__{
      header: %Header{format: format, track_count: track_count, division: division},
      tracks: parse_tracks(rest, [])
    }

  end

  defp parse_tracks(<<>>, tracks) do
    Enum.reverse(tracks)
  end

  defp parse_tracks("MTrk" <> <<length::integer-size(32), rest::binary>>, tracks) do
    <<track_bin::binary-size(length), rest::binary>> = rest

    track = %Track{events: parse_track_events(track_bin)}

    parse_tracks(rest, [track | tracks])
  end

  defp parse_variable_integer(<<1::1, num1::bitstring-size(7), 1::1, num2::bitstring-size(7), 1::1, num3::bitstring-size(7), 0::1, num4::bitstring-size(7), rest::binary>>) do
    <<num::integer-size(28)>> = <<num1::bitstring, num2::bitstring, num3::bitstring, num4::bitstring>>
    {num, rest}
  end

  defp parse_variable_integer(<<1::1, num1::bitstring-size(7), 1::1, num2::bitstring-size(7), 0::1, num3::bitstring-size(7), rest::binary>>) do
    <<num::integer-size(21)>> = <<num1::bitstring, num2::bitstring, num3::bitstring>>
    {num, rest}
  end

  defp parse_variable_integer(<<1::1, num1::bitstring-size(7), 0::1, num2::bitstring-size(7), rest::binary>>) do
    <<num::integer-size(14)>> = <<num1::bitstring, num2::bitstring>>
    {num, rest}
  end

  defp parse_variable_integer(<<0::1, num::integer-size(7), rest::binary>>) do
    {num, rest}
  end

  defp parse_track_events(bin, previous_event \\ nil, events \\ [])

  defp parse_track_events(<<>>, _previous_event, events) do
    Enum.reverse(events)
  end

  defp parse_track_events(bin, previous_event, events) do
    {delta_time, rest} = parse_variable_integer(bin)
    {event, rest} = do_parse_event(rest, previous_event)

    IO.inspect(event)

    parse_track_events(rest, event, [{delta_time, event} | events])
  end

  defp do_parse_event(<<first, rest::binary>>, _previous_event) when first in [0xF0, 0xF7] do
    {length, rest} = parse_variable_integer(rest)

    <<data::binary-size(length), rest::binary>> = rest

    {{:sysex_event, data}, rest}
  end

  defp do_parse_event(<<0xFF, type, rest::binary>>, _previous_event) do
    {length, rest} = parse_variable_integer(rest)

    <<data::binary-size(length), rest::binary>> = rest

    {{:meta_event, type, data}, rest}
  end

  defp do_parse_event(<<1::1, status::3, channel::4, 0::1, data1::7, rest::binary>>, _previous_event) when status in [0b100, 0b101] do
    message = %Message{
      type: status,
      channel: channel,
      data: data1
    }

    {message, rest}
  end

  defp do_parse_event(<<0::1, data1::7, rest::binary>>, %{type: type, channel: channel}) when type in [0b100, 0b101] do
    message = %Message{
      type: type,
      channel: channel,
      data: data1
    }

    {message, rest}
  end

  defp do_parse_event(<<1::1, status::3, channel::4, 0::1, data1::7, 0::1, data2::7, rest::binary>>, _previous_event) do
    message = %Message{
      type: status,
      channel: channel,
      data: {data1, data2}
    }

    {message, rest}
  end

  defp do_parse_event(<<0::1, data1::7, 0::1, data2::7, rest::binary>>, %{type: type, channel: channel}) do
    message = %Message{
      type: type,
      channel: channel,
      data: {data1, data2}
    }

    {message, rest}
  end



  def play(_midi) do
    raise "TODO"
  end
end
