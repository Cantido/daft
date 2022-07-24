attack = Daft.WaveFunction.ramp(0.001)
release = Daft.WaveFunction.ramp_down(0.1) |> Daft.WaveFunction.timeshift(-0.15)

adsr = Daft.WaveFunction.zip_with(attack, release, &*/2)

(Daft.Scale.major() ++ Enum.reverse(Daft.Scale.major()))
|> Daft.Scale.to_pitches(Daft.Pitch.note(:a4))
|> Enum.map(fn pitch ->
  Daft.WaveFunction.sine(pitch)
  |> Daft.WaveFunction.zip_with(adsr, &*/2)
end)
|> Enum.map(fn wave ->
  Daft.Sample.sample_with(48_000, 0.25, wave.function)
end)
|> Daft.Sample.concat()
|> Daft.Sample.play()
