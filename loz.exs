
tempo = 130
quarter = (60 / tempo)

half = 2 * quarter

triplet = quarter/ 3

[
  {:a4, half},
  {:rest, triplet * 2},
  {:a4, triplet},
  {:a4, triplet},
  {:a4, triplet},
  {:a4, triplet},

  {:a4, triplet * 2},
  {:g4, triplet},
  {:a4, quarter},
  {:rest, triplet * 2},
  {:a4, triplet},
  {:a4, triplet},
  {:a4, triplet},
  {:a4, triplet},

  {:a4, triplet * 2},
  {:g4, triplet},
  {:a4, quarter},
  {:rest, triplet * 2},
  {:a4, triplet},
  {:a4, triplet},
  {:a4, triplet},
  {:a4, triplet},

  {:a4, quarter / 2},
  {:e4, quarter / 4},
  {:e4, quarter / 4},
  {:e4, quarter / 2},
  {:e4, quarter / 4},
  {:e4, quarter / 4},
  {:e4, quarter / 2},
  {:e4, quarter / 4},
  {:e4, quarter / 4},
  {:e4, quarter / 2},
  {:e4, quarter / 2}
]
|> Enum.map(fn {note, duration} ->
  wave =
    case note do
      :rest -> Daft.WaveFunction.constant(0)
      note ->
        attack = Daft.WaveFunction.ramp(0.001)
        release = Daft.WaveFunction.ramp_down(0.1) |> Daft.WaveFunction.timeshift(-duration + 0.1)

        adsr = Daft.WaveFunction.zip_with(attack, release, &*/2)

        Daft.Pitch.note(note)
        |> Daft.WaveFunction.sine()
        |> Daft.WaveFunction.zip_with(adsr, &*/2)
    end

  Daft.Sample.sample_with(48_000, duration, wave.function)
end)
|> Daft.Sample.concat()
|> Daft.Sample.play()
