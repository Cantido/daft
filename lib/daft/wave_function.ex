defmodule Daft.WaveFunction do
  @enforce_keys [:function]
  defstruct [:function]

  def sine(hz) do
    omega = hz * 2 * :math.pi()

    %__MODULE__{
      function: fn t ->
        :math.sin(omega * t)
      end
    }
  end
end
