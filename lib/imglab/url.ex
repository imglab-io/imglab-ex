defmodule Imglab.Url do
  @moduledoc false

  alias Imglab.Source
  alias Imglab.Signature
  alias Imglab.Url.Utils

  @spec url(binary | Source.t(), binary, keyword) :: binary
  def url(source, path, params \\ [])

  def url(source_name, path, params) when is_binary(source_name) and is_binary(path) and is_list(params) do
    url(Source.new(source_name), path, params)
  end

  def url(%Source{} = source, path, params) when is_binary(path) and is_list(params) do
    normalized_path = Utils.normalize_path(path)
    normalized_params = Utils.normalize_params(params)

    URI.to_string(%URI{
      scheme: Source.scheme(source),
      host: Source.host(source),
      port: source.port,
      path: Path.join("/", Source.path(source, encode_path(normalized_path))),
      query: encode_params(source, normalized_path, normalized_params)
    })
  end

  @spec encode_path(binary) :: binary
  defp encode_path(path) when is_binary(path) do
    if Utils.web_uri?(path) do
      encode_path_component(path)
    else
      path
      |> String.split("/")
      |> Enum.map_join("/", &encode_path_component/1)
    end
  end

  @spec encode_path_component(binary) :: binary
  defp encode_path_component(path_component) when is_binary(path_component) do
    URI.encode(path_component, &URI.char_unreserved?/1)
  end

  @spec encode_params(Source.t(), binary, list) :: binary
  defp encode_params(%Source{} = source, path, params) when is_binary(path) and is_list(params) and length(params) > 0 do
    if Source.is_secure?(source) do
      signature = Signature.generate(source, path, URI.encode_query(params))

      URI.encode_query(params ++ [{"signature", signature}])
    else
      URI.encode_query(params)
    end
  end

  defp encode_params(%Source{} = source, path, _params) when is_binary(path) do
    if Source.is_secure?(source) do
      signature = Signature.generate(source, path)

      URI.encode_query(signature: signature)
    else
      nil
    end
  end
end
