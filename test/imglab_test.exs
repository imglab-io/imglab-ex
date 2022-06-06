defmodule ImglabTest do
  use ExUnit.Case
  doctest Imglab

  import Imglab.Color
  import Imglab.Position

  alias Imglab.Source

  @secure_key "ixUd9is/LDGBw6NPfLCGLjO/WraJlHdytC1+xiIFj22mXAWs/6R6ws4gxSXbDcUHMHv0G+oiTgyfMVsRS2b3"
  @secure_salt "c9G9eYKCeWen7vkEyV1cnr4MZkfLI/yo6j72JItzKHjMGDNZKqPFzRtup//qiT51HKGJrAha6Gv2huSFLwJr"

  describe "url/3 using source name" do
    test "without params" do
      url = Imglab.url("assets", "example.jpeg")

      assert url == "https://assets.imglab-cdn.net/example.jpeg"
    end

    test "with params" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png"
    end

    test "with params using string path" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, watermark: "example.svg", format: "png")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=example.svg&format=png"
    end

    test "with params using string path with inline params" do
      url =
        Imglab.url(
          "assets",
          "example.jpeg",
          width: 200,
          height: 300,
          watermark: "example.svg?width=100&format=png",
          format: "png"
        )

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=example.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    test "with params using rgb color macro" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, background_color: color(255, 128, 122))

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&background-color=255%2C128%2C122"
    end

    test "with params using rgba color macro" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, background_color: color(255, 128, 122, 128))

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&background-color=255%2C128%2C122%2C128"
    end

    test "with params using named color macro" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, background_color: color("blue"))

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&background-color=blue"
    end

    test "with params using horizontal and vertical position macro" do
      url =
        Imglab.url("assets", "example.jpeg", width: 200, height: 300, mode: "crop", crop: position("left", "bottom"))

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&mode=crop&crop=left%2Cbottom"
    end

    test "with params using vertical and horizontal position macro" do
      url =
        Imglab.url("assets", "example.jpeg", width: 200, height: 300, mode: "crop", crop: position("bottom", "left"))

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&mode=crop&crop=bottom%2Cleft"
    end

    test "with params using position macro" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, mode: "crop", crop: position("left"))

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&mode=crop&crop=left"
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

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fassets.imglab-cdn.net%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png"
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

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fassets.imglab-cdn.net%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    test "with params using atoms with underscores" do
      url = Imglab.url("assets", "example.jpeg", trim: "color", trim_color: "orange")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?trim=color&trim-color=orange"
    end

    test "with params using atoms with hyphens" do
      url = Imglab.url("assets", "example.jpeg", trim: "color", "trim-color": "orange")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?trim=color&trim-color=orange"
    end

    test "with expires param using a DateTime struct" do
      url = Imglab.url("assets", "example.jpeg", width: 200, height: 300, expires: DateTime.from_unix!(1464096368))

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&expires=1464096368"
    end

    test "with path starting with slash" do
      url = Imglab.url("assets", "/example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png"
    end

    test "with path starting with slash using reserved characters" do
      url = Imglab.url("assets", "/example image%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    test "with path starting and ending with slash" do
      url = Imglab.url("assets", "/example.jpeg/", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png"
    end

    test "with path starting and ending with slash using reserved characters" do
      url = Imglab.url("assets", "/example image%2C01%2C02.jpeg/", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    test "with subfolder path starting with slash" do
      url = Imglab.url("assets", "/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/subfolder/example.jpeg?width=200&height=300&format=png"
    end

    test "with subfolder path starting with slash using reserved characters" do
      url = Imglab.url("assets", "/subfolder images/example image%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/subfolder%20images/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    test "with subfolder path starting and ending with slash" do
      url = Imglab.url("assets", "/subfolder/example.jpeg/", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/subfolder/example.jpeg?width=200&height=300&format=png"
    end

    test "with subfolder path starting and ending with slash using reserved characters" do
      url = Imglab.url("assets", "/subfolder images/example image%2C01%2C02.jpeg/", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/subfolder%20images/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    test "with path using a http url" do
      url = Imglab.url("assets", "http://assets.com/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/http%3A%2F%2Fassets.com%2Fsubfolder%2Fexample.jpeg?width=200&height=300&format=png"
    end

    test "with path using a http url with reserved characters" do
      url = Imglab.url("assets", "http://assets.com/subfolder/example%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/http%3A%2F%2Fassets.com%2Fsubfolder%2Fexample%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    test "with path using a https url" do
      url = Imglab.url("assets", "https://assets.com/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/https%3A%2F%2Fassets.com%2Fsubfolder%2Fexample.jpeg?width=200&height=300&format=png"
    end

    test "with path using a https url with reserved characters" do
      url = Imglab.url("assets", "https://assets.com/subfolder/example%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/https%3A%2F%2Fassets.com%2Fsubfolder%2Fexample%252C01%252C02.jpeg?width=200&height=300&format=png"
    end
  end

  describe "url/3 using source" do
    test "without params" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("example.jpeg")

      assert url == "https://assets.imglab-cdn.net/example.jpeg"
    end

    test "with params" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png"
    end

    test "with params using string path" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("example.jpeg", width: 200, height: 300, watermark: "example.svg", format: "png")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=example.svg&format=png"
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

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=example.svg%3Fwidth%3D100%26format%3Dpng&format=png"
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

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fassets.imglab-cdn.net%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png"
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

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fassets.imglab-cdn.net%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png"
    end

    test "with params using atoms with underscores" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("example.jpeg", trim: "color", trim_color: "orange")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?trim=color&trim-color=orange"
    end

    test "with expires param using a DateTime struct" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("example.jpeg", width: 200, height: 300, expires: DateTime.from_unix!(1464096368))

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&expires=1464096368"
    end

    test "with params using atoms with hyphens" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("example.jpeg", trim: "color", "trim-color": "orange")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?trim=color&trim-color=orange"
    end

    test "with disabled subdomains" do
      url =
        "assets"
        |> Source.new(subdomains: false)
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://imglab-cdn.net/assets/example.jpeg?width=200&height=300&format=png"
    end

    test "with disabled https" do
      url =
        "assets"
        |> Source.new(https: false)
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url == "http://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png"
    end

    test "with host" do
      url =
        "assets"
        |> Source.new(host: "imglab.net")
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab.net/example.jpeg?width=200&height=300&format=png"
    end

    test "with port" do
      url =
        "assets"
        |> Source.new(port: 8080)
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net:8080/example.jpeg?width=200&height=300&format=png"
    end

    test "with disabled subdomains, disabled https, host and port" do
      url =
        "assets"
        |> Source.new(subdomains: false, https: false, host: "imglab.net", port: 8080)
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url == "http://imglab.net:8080/assets/example.jpeg?width=200&height=300&format=png"
    end

    test "with path starting with slash" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("/example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png"
    end

    test "with path starting with slash using reserved characters" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("/example image%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    test "with path starting and ending with slash" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("/example.jpeg/", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png"
    end

    test "with path starting and ending with slash using reserved characters" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("/example image%2C01%2C02.jpeg/", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    test "with subfolder path starting with slash" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/subfolder/example.jpeg?width=200&height=300&format=png"
    end

    test "with subfolder path starting with slash using reserved characters" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("/subfolder images/example image%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/subfolder%20images/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    test "with subfolder path starting and ending with slash" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("/subfolder/example.jpeg/", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/subfolder/example.jpeg?width=200&height=300&format=png"
    end

    test "with subfolder path starting and ending with slash using reserved characters" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("/subfolder images/example image%2C01%2C02.jpeg/", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/subfolder%20images/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    test "with path using a http url" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("http://assets.com/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/http%3A%2F%2Fassets.com%2Fsubfolder%2Fexample.jpeg?width=200&height=300&format=png"
    end

    test "with path using a http url with reserved characters" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("http://assets.com/subfolder/example%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/http%3A%2F%2Fassets.com%2Fsubfolder%2Fexample%252C01%252C02.jpeg?width=200&height=300&format=png"
    end

    test "with path using a https url" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("https://assets.com/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/https%3A%2F%2Fassets.com%2Fsubfolder%2Fexample.jpeg?width=200&height=300&format=png"
    end

    test "with path using a https url with reserved characters" do
      url =
        "assets"
        |> Source.new()
        |> Imglab.url("https://assets.com/subfolder/example%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/https%3A%2F%2Fassets.com%2Fsubfolder%2Fexample%252C01%252C02.jpeg?width=200&height=300&format=png"
    end
  end

  describe "url/3 using secure source" do
    test "without params" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("example.jpeg")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?signature=aRgmnJ-7b2A0QLxXpR3cqrHVYmCfpRCOglL-nsp7SdQ"
    end

    test "with params" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    test "with params using string path" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("example.jpeg", width: 200, height: 300, watermark: "example.svg", format: "png")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=example.svg&format=png&signature=xrwElVGVPyOrcTCNFnZiAa-tzkUp1ISrjnvEShSVsAg"
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

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=example.svg%3Fwidth%3D100%26format%3Dpng&format=png&signature=0yhBOktmTTVC-ANSxMuGK_LakyjCOlnGTSN3I13B188"
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

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Fassets.imglab-cdn.net%2Fexample.svg%3Fwidth%3D100%26format%3Dpng%26signature%3DiKKUBWG4kZBv6CVxwaWGPpHd9LLTfuj9CBWamNYtWaI&format=png&signature=ZMT8l8i9hKs4aYiIUXpGcMSzOGHS8xjUlQeTrvE8ESA"
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

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&watermark=https%3A%2F%2Ffixtures.imglab-cdn.net%2Fexample.svg%3Fwidth%3D100%26format%3Dpng&format=png&signature=6BowGGEXe9wUmGa4xkhoscfPkqrLGumkIglhPQEkNuo"
    end

    test "with params using atoms with underscores" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("example.jpeg", trim: "color", trim_color: "orange")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?trim=color&trim-color=orange&signature=cfYzBKvaWJhg_4ArtL5IafGYU6FEgRb_5ZADIgvviWw"
    end

    test "with params using atoms with hyphens" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("example.jpeg", trim: "color", "trim-color": "orange")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?trim=color&trim-color=orange&signature=cfYzBKvaWJhg_4ArtL5IafGYU6FEgRb_5ZADIgvviWw"
    end

    test "with expires param using a DateTime struct" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("example.jpeg", width: 200, height: 300, expires: DateTime.from_unix!(1464096368))

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&expires=1464096368&signature=DpkRMiecDlOaQAQM5IQ8Cd4ek8nGvfPxV6XmCN0GbAU"
    end

    test "with disabled subdomains" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt, subdomains: false)
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://imglab-cdn.net/assets/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    test "with disabled https" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt, https: false)
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url == "http://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    test "with host" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt, host: "imglab.net")
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab.net/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    test "with port" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt, port: 8080)
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net:8080/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    test "with disabled subdomains, disabled https, host and port" do
      url =
        "assets"
        |> Source.new(
          secure_key: @secure_key,
          secure_salt: @secure_salt,
          subdomains: false,
          https: false,
          host: "imglab.net",
          port: 8080
        )
        |> Imglab.url("example.jpeg", width: 200, height: 300, format: "png")

      assert url == "http://imglab.net:8080/assets/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    test "with path starting with slash" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("/example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    test "with path starting with slash using reserved characters" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("/example image%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png&signature=yZcUhTCB9VB3qzjyIJCCX_pfJ76Gb6kHe7KwusAPl-w"
    end

    test "with path starting and ending with slash" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("/example.jpeg/", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/example.jpeg?width=200&height=300&format=png&signature=VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    test "with path starting and ending with slash using reserved characters" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("/example image%2C01%2C02.jpeg/", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png&signature=yZcUhTCB9VB3qzjyIJCCX_pfJ76Gb6kHe7KwusAPl-w"
    end

    test "with subfolder path starting with slash" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/subfolder/example.jpeg?width=200&height=300&format=png&signature=3jydAIXhF8Nn_LXKhog2flf7FsACzISi_sXCKmASkOs"
    end

    test "with subfolder path starting with slash using reserved characters" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("/subfolder images/example image%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/subfolder%20images/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png&signature=2oAmYelI7UEnvqSSPCfUA25TmS7na1FRVTaxfe5ADyY"
    end

    test "with subfolder path starting and ending with slash" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("/subfolder/example.jpeg/", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/subfolder/example.jpeg?width=200&height=300&format=png&signature=3jydAIXhF8Nn_LXKhog2flf7FsACzISi_sXCKmASkOs"
    end

    test "with subfolder path starting and ending with slash using reserved characters" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("/subfolder images/example image%2C01%2C02.jpeg/", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/subfolder%20images/example%20image%252C01%252C02.jpeg?width=200&height=300&format=png&signature=2oAmYelI7UEnvqSSPCfUA25TmS7na1FRVTaxfe5ADyY"
    end

    test "with path using a http url" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("http://assets.com/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/http%3A%2F%2Fassets.com%2Fsubfolder%2Fexample.jpeg?width=200&height=300&format=png&signature=MuzfKbHDJY6lzeFQGRcsCS8DzxgL4nCpIowOMFLR1kA"
    end

    test "with path using a http url with reserved characters" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("http://assets.com/subfolder/example%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/http%3A%2F%2Fassets.com%2Fsubfolder%2Fexample%252C01%252C02.jpeg?width=200&height=300&format=png&signature=78e-ysfcy3d0e0rj70QJQ3wpuwI_hAl9ZYxIUVRw62I"
    end

    test "with path using a https url" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("https://assets.com/subfolder/example.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/https%3A%2F%2Fassets.com%2Fsubfolder%2Fexample.jpeg?width=200&height=300&format=png&signature=7Dp8Q01u_5YmpmH-j_y4P5vzOn_9EGvh77B3fi2Ke-s"
    end

    test "with path using a https url with reserved characters" do
      url =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Imglab.url("https://assets.com/subfolder/example%2C01%2C02.jpeg", width: 200, height: 300, format: "png")

      assert url == "https://assets.imglab-cdn.net/https%3A%2F%2Fassets.com%2Fsubfolder%2Fexample%252C01%252C02.jpeg?width=200&height=300&format=png&signature=-zvh2hWXP8bHkoJVh8AdJFe9Kqdd1HpP1c2UmuQcYFQ"
    end
  end
end
