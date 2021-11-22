defmodule Imglab.SignatureTest do
  use ExUnit.Case
  doctest Imglab.Signature

  alias Imglab.Source
  alias Imglab.Signature

  @secure_key "ixUd9is/LDGBw6NPfLCGLjO/WraJlHdytC1+xiIFj22mXAWs/6R6ws4gxSXbDcUHMHv0G+oiTgyfMVsRS2b3"
  @secure_salt "c9G9eYKCeWen7vkEyV1cnr4MZkfLI/yo6j72JItzKHjMGDNZKqPFzRtup//qiT51HKGJrAha6Gv2huSFLwJr"

  describe "generate/3" do
    test "with encoded_params" do
      signature =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Signature.generate("example.jpeg", URI.encode_query(width: 200, height: 300, format: "png"))

      assert signature == "VJ159IlBl_AlN59QWvyJov5SlQXlrZNpXgDJLJgzP8g"
    end

    test "without encoded_params" do
      signature =
        "assets"
        |> Source.new(secure_key: @secure_key, secure_salt: @secure_salt)
        |> Signature.generate("example.jpeg")

      assert signature == "aRgmnJ-7b2A0QLxXpR3cqrHVYmCfpRCOglL-nsp7SdQ"
    end
  end
end
