defmodule Imglab.UtilsTest do
  use ExUnit.Case
  doctest Imglab.Utils

  alias Imglab.Utils

  test "normalize_path/1" do
    assert Utils.normalize_path("") == ""
    assert Utils.normalize_path("example.jpeg") == "example.jpeg"
    assert Utils.normalize_path("/example.jpeg") == "example.jpeg"
    assert Utils.normalize_path("//example.jpeg") == "example.jpeg"
    assert Utils.normalize_path("example.jpeg/") == "example.jpeg"
    assert Utils.normalize_path("example.jpeg//") == "example.jpeg"
    assert Utils.normalize_path("/example.jpeg/") == "example.jpeg"
    assert Utils.normalize_path("//example.jpeg//") == "example.jpeg"
    assert Utils.normalize_path("subfolder/example.jpeg") == "subfolder/example.jpeg"
    assert Utils.normalize_path("/subfolder/example.jpeg") == "subfolder/example.jpeg"
    assert Utils.normalize_path("//subfolder/example.jpeg") == "subfolder/example.jpeg"
    assert Utils.normalize_path("subfolder/example.jpeg/") == "subfolder/example.jpeg"
    assert Utils.normalize_path("subfolder/example.jpeg//") == "subfolder/example.jpeg"
    assert Utils.normalize_path("/subfolder/example.jpeg/") == "subfolder/example.jpeg"
    assert Utils.normalize_path("//subfolder/example.jpeg//") == "subfolder/example.jpeg"
  end

  test "normalize_params/1" do
    assert Utils.normalize_params([]) == []
    assert Utils.normalize_params(width: 200, height: 300) == [{"width", 200}, {"height", 300}]
    assert Utils.normalize_params(trim: "color", trim_color: "orange") == [{"trim", "color"}, {"trim-color", "orange"}]
    assert Utils.normalize_params(trim: "color", "trim-color": "orange") == [{"trim", "color"}, {"trim-color", "orange"}]
  end
end
