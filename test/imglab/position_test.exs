defmodule Imglab.PositionTest do
  use ExUnit.Case
  doctest Imglab.Position

  import Imglab.Position

  describe "position/2" do
    test "using horizontal and vertical positions" do
      assert position("left", "top") == "left,top"
      assert position("left", "middle") == "left,middle"
      assert position("left", "bottom") == "left,bottom"
      assert position("center", "top") == "center,top"
      assert position("center", "middle") == "center,middle"
      assert position("center", "bottom") == "center,bottom"
      assert position("right", "top") == "right,top"
      assert position("right", "middle") == "right,middle"
      assert position("right", "bottom") == "right,bottom"
    end

    test "using vertical and horizontal positions" do
      assert position("top", "left") == "top,left"
      assert position("top", "center") == "top,center"
      assert position("top", "right") == "top,right"
      assert position("middle", "left") == "middle,left"
      assert position("middle", "center") == "middle,center"
      assert position("middle", "right") == "middle,right"
      assert position("bottom", "left") == "bottom,left"
      assert position("bottom", "center") == "bottom,center"
      assert position("bottom", "right") == "bottom,right"
    end
  end

  test "position/1" do
    assert position("left") == "left"
    assert position("center") == "center"
    assert position("right") == "right"
    assert position("top") == "top"
    assert position("middle") == "middle"
    assert position("bottom") == "bottom"
  end
end
