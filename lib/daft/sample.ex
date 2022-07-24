defmodule Daft.Sample do
  @enforce_keys [:sample_rate]
  defstruct [
    sample_rate: nil,
    samples: []
  ]

  @doc """
  Returns a `Stream` of float timestamps (in seconds) that samples should occur at, given a sample rate.
  """
  def sample_timestamps(sample_rate) do
    sample_period = 1 / sample_rate

    Stream.iterate(0, fn prev ->
      prev + sample_period
    end)
  end

  @doc """
  Builds a sample from a sampler function.

  The sampler function is called with the timestamp (in seconds) of each sample.

  For example, to make a sine wave at 440 Hz, for one second, you can use `:math.sin` as your sampler function:

      Daft.Sample.sample_with(48_000, 1, fn t -> :math.sin(440 * 2 * :math.pi() * t) end)
  """
  def sample_with(rate, duration, sampler) do
    samples =
      sample_timestamps(rate)
      |> Stream.take_while(&(&1 < duration))
      |> Stream.map(sampler)

    %__MODULE__{
      sample_rate: rate,
      samples: samples
    }
  end

  def play(sample) do
    filename = Path.join(System.tmp_dir!(), to_string(System.system_time()))

    File.write!(filename, to_binary(sample.samples))

    System.cmd("ffplay", ["-f", "f64be", "-ar", Integer.to_string(sample.sample_rate), "-nodisp", "-autoexit", filename])

    File.rm!(filename)
  end

  defp to_binary(samples) do
    Enum.reduce(samples, <<>>, fn x, acc ->
      acc <> <<x::float>>
    end)
  end
end
