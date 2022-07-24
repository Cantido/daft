defmodule Daft.Scale do
  def major, do: [0, 2, 4, 5, 7, 9, 11, 12]

  def to_pitches(scale, base) do
    Enum.map(scale, &Daft.Pitch.shift_semitones(base, &1))
  end
end
