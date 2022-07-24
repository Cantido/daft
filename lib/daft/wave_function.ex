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

  def ramp(len) do
    %__MODULE__{
      function: fn t ->
        min(t / len, 1)
      end
    }
  end

  def ramp_down(len) do
    %__MODULE__{
      function: fn t ->
        val = 1 - t / len

        min(1, max(val, 0))
      end
    }
  end

  def sign(wave) do
    %__MODULE__{
      function: fn t ->
        x = wave.function.(t)
        if x < 0, do: -1, else: 1
      end
    }
  end

  def square(hz) do
    sign(sine(hz))
  end

  def triangle(hz) do
    a = 1
    p =  1 / hz

    %__MODULE__{
      function: fn t ->
        (4 * a / p) * abs(:math.fmod(t - p / 4.0, p) - (p / 2)) - a
      end
    }
  end

  def constant(val) do
    %__MODULE__{
      function: fn _t -> val end
    }
  end

  def timeshift(wave, time) do
    %__MODULE__{
      function: fn t -> wave.function.(t + time) end
    }
  end

  def zip_with([wave1, wave2], zip_fun) do
    zip_with(wave1, wave2, zip_fun)
  end

  def zip_with([wave1 | [wave2 | rest]], zip_fun) do
    next = zip_with(wave1, wave2, zip_fun)
    zip_with([next | rest], zip_fun)
  end

  @doc """
  Combines two waveforms by applying a given function on each pair of sample values.

  For example, to multiply one function with another:
  """
  def zip_with(wave1, wave2, zip_fun) do

    %__MODULE__{
      function: fn t ->
        wave1_result = wave1.function.(t)
        wave2_result = wave2.function.(t)

        zip_fun.(wave1_result, wave2_result)
      end
    }
  end
end
