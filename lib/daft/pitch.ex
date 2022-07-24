defmodule Daft.Pitch do
  @moduledoc """
  Functions for calculating pitch, in Hertz.
  """

  @semitone_shifts [
    {:a4, 0},
    {:a4sharp, 1},
    {:b4flat, 1},
    {:b4, 2},
    {:c5, 3}
  ]

  @doc """
  Returns the pitch of the given note.
  """
  def note(name)

  Enum.map(@semitone_shifts, fn {name, shift} ->
    def note(unquote(name)), do: shift_semitones(440, unquote(shift))
  end)

  @doc """
  Shifts a pitch up or down a number of semitones.
  """
  def shift_semitones(pitch, semitones) do
    twelfth_root_of_two = :math.pow(2, 1.0 / 12.0)
    pitch * :math.pow(twelfth_root_of_two, semitones)
  end
end
