defmodule Daft.MIDI.Header do
  @enforce_keys [:format, :track_count, :division]
  defstruct [:format, :track_count, :division]
end
