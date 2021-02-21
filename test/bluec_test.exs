defmodule BluecTest do
  use ExUnit.Case
  doctest Bluec

  test "greets the world" do
    assert Bluec.hello() == :world
  end
end
