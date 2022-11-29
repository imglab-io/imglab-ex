defmodule Imglab.Url do
  @moduledoc false

  import Kernel, except: [to_string: 1]

  alias Imglab.Source
  alias Imglab.Signature
  alias Imglab.Url.Utils

  defstruct [:source, :path, :params]

  @type t :: %__MODULE__{
          source: Source.t(),
          path: binary,
          params: keyword
        }

  @spec new(Source.t(), binary, keyword) :: t
  def new(%Source{} = source, path, params) when is_binary(path) and is_list(params) do
    %__MODULE__{
      source: source,
      path: Utils.normalize_path(path),
      params: Utils.normalize_params(params)
    }
  end

  @spec to_string(t) :: binary
  def to_string(%__MODULE__{} = url) do
    url
    |> to_uri()
    |> URI.to_string()
  end

  @spec to_uri(t) :: URI.t()
  defp to_uri(%__MODULE__{source: source} = url) do
    %URI{
      scheme: Source.scheme(source),
      host: Source.host(source),
      port: source.port,
      path: Path.join("/", Source.path(source, encode_path(url))),
      query: encode_params(url)
    }
  end

  @spec encode_path(t) :: binary
  defp encode_path(%__MODULE__{path: path}) do
    if Utils.web_uri?(path) do
      encode_path_component(path)
    else
      path
      |> String.split("/")
      |> Enum.map(&encode_path_component/1)
      |> Enum.join("/")
    end
  end

  @spec encode_path_component(binary) :: binary
  defp encode_path_component(path_component) when is_binary(path_component) do
    URI.encode(path_component, &URI.char_unreserved?/1)
  end

  @spec encode_params(t) :: binary
  defp encode_params(%__MODULE__{source: source, path: path, params: params}) when length(params) > 0 do
    if Source.is_secure?(source) do
      signature = Signature.generate(source, path, URI.encode_query(params))

      URI.encode_query(params ++ [{"signature", signature}])
    else
      URI.encode_query(params)
    end
  end

  defp encode_params(%__MODULE__{source: source, path: path}) do
    if Source.is_secure?(source) do
      signature = Signature.generate(source, path)

      URI.encode_query(signature: signature)
    else
      nil
    end
  end
end
