defmodule Imglab.Source do
  @moduledoc """
  Provides a way to define and store information about a imglab source.
  """

  @default_subdomains false
  @default_https true
  @default_host "cdn.imglab.io"

  @derive {Inspect, except: [:secure_key, :secure_salt]}
  @enforce_keys [:name]

  defstruct [
    host: @default_host,
    https: @default_https,
    name: nil,
    port: nil,
    secure_key: nil,
    secure_salt: nil,
    subdomains: @default_subdomains
  ]

  @type t :: %__MODULE__{
    host: binary,
    https: boolean,
    name: binary,
    port: nil | :inet.port_number,
    secure_key: nil | binary,
    secure_salt: nil | binary,
    subdomains: boolean
  }

  @doc """
  Returns a [Source struct](`t:t/0`) with the specified options for the source.

  `name` must be a `string` indicating the name of the source.

  ## Options

  The accepted options are:

    * `:host` - a `string` specifying the host where the imglab server is located, only for imglab on-premises (default: `"cdn.imglab.io"`)
    * `:https` - a `boolean` value specifying if the source should use https or not (default: `true`)
    * `:port` - a `:inet.port_number` specifying a port where the imglab server is located, only for imglab on-premises
    * `:secure_key` - a `string` specifying the source secure key
    * `:secure_salt` - a `string` specifying the source secure salt
    * `:subdomains` - a `boolean` value specifying if the source should be specified using subdomains instead of using the path, only for imglab on-premises (default: `false`)

  > Note: `secure_key` and `secure_salt` paramaters are secrets that should not be added to the code. Please use environment vars or other secure method to use them in your project.

  ## Examples

      iex> Imglab.Source.new("assets")
      %Imglab.Source{
        host: "cdn.imglab.io",
        https: true,
        name: "assets",
        port: nil,
        secure_key: nil,
        secure_salt: nil,
        subdomains: false
      }

      iex> Imglab.Source.new("assets", subdomains: true)
      %Imglab.Source{
        host: "cdn.imglab.io",
        https: true,
        name: "assets",
        port: nil,
        secure_key: nil,
        secure_salt: nil,
        subdomains: true
      }

      iex> Imglab.Source.new("assets", https: false, host: "imglab.net", port: 8080)
      %Imglab.Source{
        host: "imglab.net",
        https: false,
        name: "assets",
        port: 8080,
        secure_key: nil,
        secure_salt: nil,
        subdomains: false
      }

      iex> Imglab.Source.new("assets", secure_key: "secure-key", secure_salt: "secure-salt")
      %Imglab.Source{
        host: "cdn.imglab.io",
        https: true,
        name: "assets",
        port: nil,
        secure_key: "secure-key",
        secure_salt: "secure-salt",
        subdomains: false
      }

  """
  @spec new(binary, keyword) :: t
  def new(name, options \\ []) when is_binary(name) do
    host = Keyword.get(options, :host, @default_host)
    https = Keyword.get(options, :https, @default_https)
    port = Keyword.get(options, :port)
    secure_key = Keyword.get(options, :secure_key)
    secure_salt = Keyword.get(options, :secure_salt)
    subdomains = Keyword.get(options, :subdomains, @default_subdomains)

    %__MODULE__{
      host: host,
      https: https,
      name: name,
      port: port,
      secure_key: secure_key,
      secure_salt: secure_salt,
      subdomains: subdomains
    }
  end

  @doc false
  @spec scheme(t) :: binary
  def scheme(%__MODULE__{https: true}), do: "https"
  def scheme(%__MODULE__{}), do: "http"

  @doc false
  @spec host(t) :: binary
  def host(%__MODULE__{subdomains: true} = source), do: "#{source.name}.#{source.host}"
  def host(%__MODULE__{} = source), do: source.host

  @doc false
  @spec path(t, binary) :: binary
  def path(%__MODULE__{subdomains: true}, path) when is_binary(path), do: path
  def path(%__MODULE__{} = source, path) when is_binary(path), do: Path.join(source.name, path)

  @doc false
  @spec secure?(t) :: boolean
  def secure?(%__MODULE__{} = source) do
    !is_nil(source.secure_key) && !is_nil(source.secure_salt)
  end
end
