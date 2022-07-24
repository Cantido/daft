defmodule Daft.Pitch do
  @moduledoc """
  Functions for calculating pitch, in Hertz.
  """

  @semitone_shifts [
    {:e2, -29},
    {:f2, -28},
    {:f2sharp, -27},
    {:g2flat, -27},
    {:g2, -26},
    {:g2sharp, -25},
    {:a2flat, -25},
    {:a2, -24},
    {:a2sharp, -23},
    {:b2flat, -23},
    {:b2, -22},

    {:c3, -21},
    {:c3sharp, -20},
    {:d3flat, -20},
    {:d3, -19},
    {:d3sharp, -18},
    {:e3flat, -18},
    {:e3, -17},
    {:f3, -16},
    {:f3sharp, -15},
    {:g3flat, -15},
    {:g3, -14},
    {:g3sharp, -13},
    {:a3flat, -13},
    {:a3, -12},
    {:a3sharp, -11},
    {:b3flat, -11},
    {:b3, -10},

    {:c4, -9},
    {:c4sharp, -8},
    {:d4flat, -8},
    {:d4, -7},
    {:d4sharp, -6},
    {:e4flat, -6},
    {:e4, -5},
    {:f4, -4},
    {:f4sharp, -3},
    {:g4flat, -3},
    {:g4, -2},
    {:g4sharp, -1},
    {:a4flat, -1},
    {:a4, 0},
    {:a4sharp, 1},
    {:b4flat, 1},
    {:b4, 2},

    {:c5, 3},
    {:c5sharp, 4},
    {:d5flat, 4},
    {:d5, 5},
    {:d5sharp, 6},
    {:e5flat, 6},
    {:e5, 7},
    {:f5, 8},
    {:f5sharp, 9},
    {:g5flat, 9},
    {:g5, 10},
    {:g5sharp, 11},
    {:a5flat, 11},
    {:a5, 12},
    {:a5sharp, 13},
    {:b5flat, 13}
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
