defmodule Imglab.SequenceTest do
  use ExUnit.Case
  doctest Imglab.Sequence

  import Imglab.Sequence

  describe "sequence/3" do
    test "returns an empty list when the size of the sequence is a negative integer" do
      assert sequence(100, 8192, -1) == []
      assert sequence(8192, 100, -1) == []
    end

    test "returns an empty list when the size of the sequence is zero" do
      assert sequence(100, 8192, 0) == []
      assert sequence(8192, 100, 0) == []
    end

    test "returns a list with expected ascending order sequence" do
      assert sequence(100, 8192, 1) == [100]
      assert sequence(100, 8192, 2) == [100, 8192]
      assert sequence(100, 8192, 3) == [100, 905, 8192]
      assert sequence(100, 8192, 4) == [100, 434, 1886, 8192]
      assert sequence(100, 8192, 16) == [100, 134, 180, 241, 324, 434, 583, 781, 1048, 1406, 1886, 2530, 3394, 4553, 6107, 8192]
      assert sequence(100, 8192, 32) == [100, 115, 133, 153, 177, 204, 235, 270, 312, 359, 414, 477, 550, 634, 731, 843, 972, 1120, 1291, 1488, 1716, 1978, 2280, 2628, 3029, 3492, 4025, 4640, 5348, 6165, 7107, 8192]
    end

    test "returns a list with expected descending order sequence" do
      assert sequence(8192, 100, 1) == [8192]
      assert sequence(8192, 100, 2) == [8192, 100]
      assert sequence(8192, 100, 3) == [8192, 905, 100]
      assert sequence(8192, 100, 4) == [8192, 1886, 434, 100]
      assert sequence(8192, 100, 16) == [8192, 6107, 4553, 3394, 2530, 1886, 1406, 1048, 781, 583, 434, 324, 241, 180, 134, 100]
      assert sequence(8192, 100, 32) == [8192, 7107, 6165, 5348, 4640, 4025, 3492, 3029, 2628, 2280, 1978, 1716, 1488, 1291, 1120, 972, 843, 731, 634, 550, 477, 414, 359, 312, 270, 235, 204, 177, 153, 133, 115, 100]
    end
  end

  describe "sequence/2" do
    test "returns a list with sequence default size" do
      assert sequence(100, 8192) == [100, 134, 180, 241, 324, 434, 583, 781, 1048, 1406, 1886, 2530, 3394, 4553, 6107, 8192]
      assert sequence(8192, 100) == [8192, 6107, 4553, 3394, 2530, 1886, 1406, 1048, 781, 583, 434, 324, 241, 180, 134, 100]
    end
  end
end
