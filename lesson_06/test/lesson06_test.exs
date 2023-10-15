defmodule Lesson06Test do
  use ExUnit.Case
  doctest Lesson06

  test "greets the world" do
    assert Lesson06.hello() == :world
  end
end
