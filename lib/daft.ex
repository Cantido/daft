defmodule Daft do
  @moduledoc """
  Documentation for `Daft`.
  """

  def wave(hz, duration, samplerate) do
    wave_function = Daft.WaveFunction.sine(hz)

    Daft.Sample.sample_with(samplerate, duration, wave_function.function)
  end
end
