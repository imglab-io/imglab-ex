defmodule ImglabTest do
  use ExUnit.Case
  doctest Imglab

  import Imglab.Color
  import Imglab.Position

  alias Imglab.Source

  @secure_key "ixUd9is/LDGBw6NPfLCGLjO/WraJlHdytC1+xiIFj22mXAWs/6R6ws4gxSXbDcUHMHv0G+oiTgyfMVsRS2b3"
  @secure_salt "c9G9eYKCeWen7vkEyV1cnr4MZkfLI/yo6j72JItzKHjMGDNZKqPFzRtup//qiT51HKGJrAha6Gv2huSFLwJr"

  describe "url/3 using source name" do
    test "with params" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png"
    end

    test "with params using string path" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, watermark: "example.svg", format: "png")

      assert url == "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=example.svg&format=png"
    end

    test "with params using string path with inline params" do
      url =
        Imglab.url("assets", "example.jpeg",
          width: 200,
          height: 300,
          watermark: "example.svg?width=100&format=png",
          format: "png"
        )

      assert url ==
               "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=example.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    test "with params using rgb color macro" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, background_color: color(255, 128, 122))

      assert url == "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&background-color=255%2C128%2C122"
    end

    test "with params using rgba color macro" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, background_color: color(255, 128, 122, 128))

      assert url ==
               "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&background-color=255%2C128%2C122%2C128"
    end

    test "with params using name color macro" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, background_color: color("blue"))

      assert url == "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&background-color=blue"
    end

    test "with params using horizontal and vertical position macro" do
      url =
        Imglab.url("assets", "example.jpeg", width: 200, height: 300, mode: "crop", crop: position("left", "bottom"))

      assert url == "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&mode=crop&crop=left%2Cbottom"
    end

    test "with params using vertical and horizontal position macro" do
      url =
        Imglab.url("assets", "example.jpeg", width: 200, height: 300, mode: "crop", crop: position("bottom", "left"))

      assert url == "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&mode=crop&crop=bottom%2Cleft"
    end

    test "with params using position macro" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, mode: "crop", crop: position("left"))

      assert url == "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&mode=crop&crop=left"
    end

    test "with params using url/3 function with source" do
      source = Source.new("assets")

      url =
        Imglab.url(
          "assets",
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: Imglab.url(source, "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert url ==
               "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fcdn.imglab.io%2Fassets%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    test "with params using url/3 function with source name" do
      url =
        Imglab.url(
          "assets",
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: Imglab.url("assets", "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert url ==
               "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fcdn.imglab.io%2Fassets%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    test "without params" do
      url = Imglab.url("assets", "example.jpeg")

      assert url == "https://cdn.imglab.io/assets/example.jpeg"
    end

    test "with params using atoms with underscores" do
      url = Imglab.url("assets", "example.jpeg", trim: "color", trim_color: "orange")

      assert url == "https://cdn.imglab.io/assets/example.jpeg?trim=color&trim-color=orange"
    end

    test "with params using atoms with hyphens" do
      url = Imglab.url("assets", "example.jpeg", trim: "color", "trim-color": "orange")

      assert url == "https://cdn.imglab.io/assets/example.jpeg?trim=color&trim-color=orange"
    end

    test "with path starting with slash" do
      url = Imglab.url("assets", "/example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png"
    end

    test "with path starting and ending with slash" do
      url = Imglab.url("assets", "/example.jpeg/", width: 200, height: 300, format: "png")

      assert url == "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png"
    end

    test "with subfolder path starting with slash" do
      url = Imglab.url("assets", "/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://cdn.imglab.io/assets/subfolder/example.jpeg?width=200&height=300&format=png"
    end

    test "with subdfolder path starting and ending with slash" do
      url = Imglab.url("assets", "/subfolder/example.jpeg/", width: 200, height: 300, format: "png")

      assert url == "https://cdn.imglab.io/assets/subfolder/example.jpeg?width=200&height=300&format=png"
    end
  end

  describe "url/3 using source" do
    test "with params" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png"
    end

    test "with params using string path" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("example.jpeg", width: 200, height: 300, watermark: "example.svg", format: "png")

      assert url == "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=example.svg&format=png"
    end

    test "with params using string path with inline params" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("example.jpeg",
          width: 200,
          height: 300,
          watermark: "example.svg?width=100&format=png",
          format: "png"
        )

      assert url ==
               "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=example.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    test "with params using url/3 with source" do
      source = Source.new("assets")

      url =
        Imglab.url(
          source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: Imglab.url(source, "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert url ==
               "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fcdn.imglab.io%2Fassets%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    test "with params using url/3 function with source name" do
      source = Source.new("assets")

      url =
        Imglab.url(
          source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: Imglab.url("assets", "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert url ==
               "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fcdn.imglab.io%2Fassets%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    test "without params" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("example.jpeg")

      assert url == "https://cdn.imglab.io/assets/example.jpeg"
    end

    test "with params using atoms with underscores" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("example.jpeg", trim: "color", trim_color: "orange")

      assert url == "https://cdn.imglab.io/assets/example.jpeg?trim=color&trim-color=orange"
    end

    test "with params using atoms with hyphens" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("example.jpeg", trim: "color", "trim-color": "orange")

      assert url == "https://cdn.imglab.io/assets/example.jpeg?trim=color&trim-color=orange"
    end

    test "with subdomains" do
      url =
        "assets"
        |> Source.new(subdomains: true)
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.cdn.imglab.io/example.jpeg?width=200&height=300&format=png"
    end

    test "with http" do
      url =
        "assets"
        |> Source.new(https: false)
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url == "http://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png"
    end

    test "with host" do
      url =
        "assets"
        |> Source.new(host: "imglab.net")
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://imglab.net/assets/example.jpeg?width=200&height=300&format=png"
    end

    test "with port" do
      url =
        "assets"
        |> Source.new(port: 8080)
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://cdn.imglab.io:8080/assets/example.jpeg?width=200&height=300&format=png"
    end

    test "with subdomains, http, host and port" do
      url =
        "assets"
        |> Source.new(subdomains: true, https: false, host: "imglab.net", port: 8080)
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url == "http://assets.imglab.net:8080/example.jpeg?width=200&height=300&format=png"
    end

    test "with path starting with slash" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("/example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png"
    end

    test "with path starting and ending with slash" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("/example.jpeg/", width: 200, height: 300, format: "png")

      assert url == "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png"
    end

    test "with subfolder path starting with slash" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://cdn.imglab.io/assets/subfolder/example.jpeg?width=200&height=300&format=png"
    end

    test "with subdfolder path starting and ending with slash" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("/subfolder/example.jpeg/", width: 200, height: 300, format: "png")

      assert url == "https://cdn.imglab.io/assets/subfolder/example.jpeg?width=200&height=300&format=png"
    end
  end

  describe "url/3 using secure source" do
    test "with params" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url ==
               "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    test "with params using string path" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("example.jpeg", width: 200, height: 300, watermark: "example.svg", format: "png")

      assert url ==
               "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=example.svg&format=png&signature=xrwElVGVPyOrcTCNFnZiAa-tzkUp1ISrjnvEShSVsAg"
    end

    test "with params using string path with inline params" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("example.jpeg",
          width: 200,
          height: 300,
          watermark: "example.svg?width=100&format=png",
          format: "png"
        )

      assert url ==
               "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=example.svg%3Fwidth%3D100%26format%3Dpng&format=png&signature=0yhBOktmTTVC-ANSxMuGK_LakyjCOlnGTSN3I13B188"
    end

    test "with params using url/3 function with source" do
      source = Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt)

      url =
        Imglab.url(
          source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: Imglab.url(source, "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert url ==
               "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fcdn.imglab.io%2Fassets%2Fexample.svg%3Fwidth%3D100%26format%3Dpng%26signature%3DiKKUBWG4kZBv6CVxwaWGPpHd9LLTfuj9CBWamNYtWaI&format=png&signature=5__R2eDq59DYQnj64dyW3VlY-earzP6uyi624Q0Q4kU"
    end

    test "with params using url/3 function with source name" do
      source = Source.new("assets", secure_key: @secure_key, secure_salt: @secure_salt)

      url =
        Imglab.url(
          source,
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: Imglab.url(Source.new("fixtures"), "example.svg", width: 100, format: "png"),
          format: "png"
        )

      assert url ==
               "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fcdn.imglab.io%2Ffixtures%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png&signature=DiMzjeskcahfac0Xsy4QNj6qoU3dvKgOuFbHT7E4usU"
    end

    test "without params" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("example.jpeg")

      assert url == "https://cdn.imglab.io/assets/example.jpeg?signature=aRgmnJ-7b2A0QLxXpR3cqrHVYmCfpRCOglL-nsp7SdQ"
    end

    test "with params using atoms with underscores" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("example.jpeg", trim: "color", trim_color: "orange")

      assert url ==
               "https://cdn.imglab.io/assets/example.jpeg?trim=color&trim-color=orange&signature=cfYzBKvaWJhg_4ArtL5IafGYU6FEgRb_5ZADIgvviWw"
    end

    test "with params using atoms with hyphens" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("example.jpeg", trim: "color", "trim-color": "orange")

      assert url ==
               "https://cdn.imglab.io/assets/example.jpeg?trim=color&trim-color=orange&signature=cfYzBKvaWJhg_4ArtL5IafGYU6FEgRb_5ZADIgvviWw"
    end

    test "with subdomains" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt, subdomains: true)
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url ==
               "https://assets.cdn.imglab.io/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    test "with http" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt, https: false)
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url ==
               "http://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    test "with host" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt, host: "imglab.net")
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url ==
               "https://imglab.net/assets/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    test "with port" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt, port: 8080)
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url ==
               "https://cdn.imglab.io:8080/assets/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    test "with subdomains, http, host and port" do
      url =
        "assets"
        |> Source.new(
          secure_key: @secure_key,
          secure_salt: @secure_salt,
          subdomains: true,
          https: false,
          host: "imglab.net",
          port: 8080
        )
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url ==
               "http://assets.imglab.net:8080/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    test "with path starting with slash" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("/example.jpeg", width: 200, height: 300, format: "png")

      assert url ==
               "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    test "with path starting and ending with slash" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("/example.jpeg/", width: 200, height: 300, format: "png")

      assert url ==
               "https://cdn.imglab.io/assets/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    test "with subfolder path starting with slash" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert url ==
               "https://cdn.imglab.io/assets/subfolder/example.jpeg?width=200&height=300&format=png&signature=3jydAIXhF8Nn_LXKhog2flf7FsACzISi_sXCKmASkOs"
    end

    test "with subdfolder path starting and ending with slash" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("/subfolder/example.jpeg/", width: 200, height: 300, format: "png")

      assert url ==
               "https://cdn.imglab.io/assets/subfolder/example.jpeg?width=200&height=300&format=png&signature=3jydAIXhF8Nn_LXKhog2flf7FsACzISi_sXCKmASkOs"
    end
  end
end
