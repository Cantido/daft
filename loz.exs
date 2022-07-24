
tempo = 130
quarter = (60 / tempo)

half = 2 * quarter

triplet = quarter/ 3

treble_chan1 =
  [
    {:b4flat, half},
    {:rest, triplet * 2},
    {:b4flat, triplet},
    {:b4flat, triplet},
    {:b4flat, triplet},
    {:b4flat, triplet},

    {:b4flat, triplet * 2},
    {:a4flat, triplet},
    {:b4flat, quarter},
    {:rest, triplet * 2},
    {:b4flat, triplet},
    {:b4flat, triplet},
    {:b4flat, triplet},
    {:b4flat, triplet},

    {:b4flat, triplet * 2},
    {:a4flat, triplet},
    {:b4flat, quarter},
    {:rest, triplet * 2},
    {:b4flat, triplet},
    {:b4flat, triplet},
    {:b4flat, triplet},
    {:b4flat, triplet},

    {:b4flat, quarter / 2},
    {:f4, quarter / 4},
    {:f4, quarter / 4},
    {:f4, quarter / 2},
    {:f4, quarter / 4},
    {:f4, quarter / 4},
    {:f4, quarter / 2},
    {:f4, quarter / 4},
    {:f4, quarter / 4},
    {:f4, quarter / 2},
    {:f4, quarter / 2},

    {:b4flat, quarter},
    {:f4, quarter + quarter * 3/4},
    {:b4flat, quarter / 4},
    {:b4flat, quarter / 4},
    {:c5, quarter / 4},
    {:d5, quarter / 4},
    {:e5flat, quarter / 4},

    {:f5, quarter * 3 / 4},
    {:rest, quarter / 4},
    {:rest, quarter},
    {:rest, quarter / 2},
    {:f5, quarter / 2},
    {:f5, triplet},
    {:g5flat, triplet},
    {:a5flat, triplet},

    {:b5flat, quarter * 3 / 4},
    {:rest, quarter / 4},
    {:rest, quarter},
    {:rest, triplet},
    {:b5flat, triplet},
    {:b5flat, triplet},
    {:b5flat, triplet},
    {:a5flat, triplet},
    {:g5flat, triplet},

    {:a5flat, triplet * 2},
    {:g5flat, triplet},
    {:f5, quarter * 2},
    {:f5, quarter},

    {:e5flat, quarter / 2},
    {:e5flat, quarter / 4},
    {:f5, quarter / 4},
    {:g5flat, quarter * 2},
    {:f5, quarter / 2},


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
          |> Daft.WaveFunction.square()
          |> Daft.WaveFunction.zip_with(adsr, &*/2)
      end

    Daft.Sample.sample_with(48_000, duration, wave.function)
  end)
  |> Daft.Sample.concat()


bass_chan1 =
  [
    {:b2, quarter},
    {:b2, triplet},
    {:b2, triplet},
    {:b2, triplet},
    {:b2, quarter},
    {:b2, quarter},

    {:a2flat, quarter},
    {:a2flat, triplet},
    {:a2flat, triplet},
    {:a2flat, triplet},
    {:a2flat, quarter},
    {:a2flat, quarter},

    {:g2flat, quarter},
    {:g2flat, triplet},
    {:g2flat, triplet},
    {:g2flat, triplet},
    {:g2flat, quarter},
    {:g2flat, quarter},

    {:f2, quarter},
    {:f2, quarter},
    {:f2, quarter},
    {:g2, quarter / 2},
    {:a3, quarter / 2},


    {:b2, quarter},
    {:b2, triplet},
    {:b2, triplet},
    {:a2flat, triplet},
    {:b2, quarter},
    {:b2, quarter},

    {:a2flat, quarter},
    {:a2flat, triplet},
    {:a2flat, triplet},
    {:e2, triplet},
    {:a2flat, quarter},
    {:a2flat, quarter},

    {:rest, quarter * 4},

    {:rest, quarter * 4},

    {:rest, quarter * 4}

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
          |> Daft.WaveFunction.triangle()
          |> Daft.WaveFunction.zip_with(adsr, &*/2)
      end

    Daft.Sample.sample_with(48_000, duration, wave.function)
  end)
  |> Daft.Sample.concat()

Daft.Sample.zip_with(treble_chan1, bass_chan1, &+/2)
|> Daft.Sample.play()
