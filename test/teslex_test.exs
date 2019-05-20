defmodule TeslexTest do
  use ExUnit.Case
  doctest Teslex

  test "greets the world" do
    assert Teslex.hello() == :world
  end
end
