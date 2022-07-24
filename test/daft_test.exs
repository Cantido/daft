defmodule DaftTest do
  use ExUnit.Case
  doctest Daft

  test "greets the world" do
    assert Daft.hello() == :world
  end
end
