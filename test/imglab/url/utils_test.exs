defmodule Imglab.Url.UtilsTest do
  use ExUnit.Case
  doctest Imglab.Url.Utils

  alias Imglab.Url.Utils

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
    assert Utils.normalize_params(width: 200, expires: 1464096368) == [{"width", 200}, {"expires", 1464096368}]
    assert Utils.normalize_params(width: 200, expires: "1464096368") == [{"width", 200}, {"expires", "1464096368"}]
    assert Utils.normalize_params(width: 200, expires: DateTime.from_unix!(1464096368)) == [{"width", 200}, {"expires", 1464096368}]
  end

  test "web_uri?/1" do
    assert Utils.web_uri?("https://assets.com/example.jpeg")
    assert Utils.web_uri?("http://assets.com/example.jpeg")
    assert Utils.web_uri?("HTTPS://assets.com/example.jpeg")
    assert Utils.web_uri?("HTTP://assets.com/example.jpeg")

    refute Utils.web_uri?("")
    refute Utils.web_uri?("example.jpeg")
    refute Utils.web_uri?("https/example.jpeg")
    refute Utils.web_uri?("http/example.jpeg")
    refute Utils.web_uri?("/https/example.jpeg")
    refute Utils.web_uri?("/example.jpeg")
    refute Utils.web_uri?("/http/example.jpeg")
  end
end
