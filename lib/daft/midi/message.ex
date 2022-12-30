defmodule Daft.MIDI.Message do
  @enforce_keys [:type, :data]
  defstruct [:type, :channel, :data]
end
