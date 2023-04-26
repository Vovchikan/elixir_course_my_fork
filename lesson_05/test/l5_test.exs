defmodule L5Test do
  use ExUnit.Case
  doctest L5

  test "greets the world" do
    assert L5.hello() == :world
  end
end
