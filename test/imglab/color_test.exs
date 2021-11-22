defmodule Imglab.ColorTest do
  use ExUnit.Case
  doctest Imglab.Color

  import Imglab.Color

  test "color/4" do
    assert color(255, 0, 0, 0) == "255,0,0,0"
    assert color(0, 255, 0, 0) == "0,255,0,0"
    assert color(0, 0, 255, 0) == "0,0,255,0"
    assert color(0, 0, 0, 255) == "0,0,0,255"
    assert color(255, 255, 255, 255) == "255,255,255,255"
  end

  test "color/3" do
    assert color(255, 0, 0) == "255,0,0"
    assert color(0, 255, 0) == "0,255,0"
    assert color(0, 0, 255) == "0,0,255"
    assert color(255, 255, 255) == "255,255,255"
  end

  test "color/1" do
    assert color("blue") == "blue"
    assert color("white") == "white"
    assert color("black") == "black"
  end
end
