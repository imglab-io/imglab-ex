defmodule Imglab.SourceTest do
  use ExUnit.Case
  doctest Imglab.Source

  alias Imglab.Source

  test "new/2" do
    assert Source.new("assets") == %Source{
             name: "assets",
             subdomains: true,
             https: true,
             host: "imglab-cdn.net",
             port: nil,
             secure_key: nil,
             secure_salt: nil
           }

    assert Source.new("assets", host: "imglab.net") == %Source{name: "assets", host: "imglab.net"}
    assert Source.new("assets", https: false) == %Source{name: "assets", https: false}
    assert Source.new("assets", port: 8080) == %Source{name: "assets", port: 8080}
    assert Source.new("assets", secure_key: "secure-key") == %Source{name: "assets", secure_key: "secure-key"}
    assert Source.new("assets", secure_salt: "secure-salt") == %Source{name: "assets", secure_salt: "secure-salt"}
    assert Source.new("assets", subdomains: false) == %Source{name: "assets", subdomains: false}
  end

  test "scheme/1" do
    assert Source.scheme(Source.new("assets")) == "https"
    assert Source.scheme(Source.new("assets", https: true)) == "https"
    assert Source.scheme(Source.new("assets", https: false)) == "http"
  end

  test "host/1" do
    assert Source.host(Source.new("assets")) == "assets.imglab-cdn.net"
    assert Source.host(Source.new("assets", subdomains: false)) == "imglab-cdn.net"
    assert Source.host(Source.new("assets", subdomains: false, host: "imglab.net")) == "imglab.net"
    assert Source.host(Source.new("assets", subdomains: true)) == "assets.imglab-cdn.net"
    assert Source.host(Source.new("assets", subdomains: true, host: "imglab.net")) == "assets.imglab.net"
  end

  test "path/2" do
    assert Source.path(Source.new("assets"), "example.jpeg") == "example.jpeg"
    assert Source.path(Source.new("assets"), "subfolder/example.jpeg") == "subfolder/example.jpeg"
    assert Source.path(Source.new("assets", subdomains: false), "example.jpeg") == "assets/example.jpeg"

    assert Source.path(Source.new("assets", subdomains: false), "subfolder/example.jpeg") ==
             "assets/subfolder/example.jpeg"

    assert Source.path(Source.new("assets", subdomains: true), "example.jpeg") == "example.jpeg"
    assert Source.path(Source.new("assets", subdomains: true), "subfolder/example.jpeg") == "subfolder/example.jpeg"
  end

  test "is_secure?/1" do
    assert Source.is_secure?(Source.new("assets")) == false
    assert Source.is_secure?(Source.new("assets", secure_key: "secure-key")) == false
    assert Source.is_secure?(Source.new("assets", secure_salt: "secure-salt")) == false
    assert Source.is_secure?(Source.new("assets", secure_key: "secure-key", secure_salt: "secure-salt")) == true
  end
end
