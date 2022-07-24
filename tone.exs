[:a4, :a4sharp, :b4, :c5]
|> Enum.map(&Daft.Pitch.note/1)
|> Enum.map(&Daft.WaveFunction.sine/1)
|> Enum.map(fn wave ->
  Daft.Sample.sample_with(48_000, 0.5, wave.function)
end)
|> Daft.Sample.concat()
|> Daft.Sample.play()
