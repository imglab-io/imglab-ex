defmodule Imglab do
  @moduledoc """
  Provides a set of functions to work with imglab services.
  """

  alias Imglab.Source
  alias Imglab.Signature
  alias Imglab.Utils

  @doc """
  Returns a formatted URL `string` with the specified parameters.

  * `source_name_or_source` must be a `string` indicating a source name or a [Source struct](`t:Imglab.Source.t/0`).
  * `path` must be a `string` indicating the path of the resource.
  * `params` must be an optional `keyword` list with the image parameters to use.

  ## Source

  The first parameter can be a `string` with the name of the source in the case that no additional settings for the source are needed:

      iex> Imglab.url("assets", "image.jpeg", width: 500, height: 600)
      "https://assets.imglab-cdn.net/image.jpeg?width=500&height=600"

  Or a [Source struct](`t:Imglab.Source.t/0`) created with `Imglab.Source.new/2` specifying additional settings for the source if needed:

      iex> "assets"
      iex> |> Imglab.Source.new()
      iex> |> Imglab.url("image.jpeg", width: 500, height: 600)
      "https://assets.imglab-cdn.net/image.jpeg?width=500&height=600"

  ### Secured sources

  You can specify a secure source and use it to generate signed URLs:

      iex> "assets"
      iex> |> Imglab.Source.new(secure_key: "qxxKNvxRONOMklcGJBVczefrJnE=", secure_salt: "e9bXw6/HIMGTWcmAYArHA5jpIAE=")
      iex> |> Imglab.url("image.jpeg", width: 500, height: 600)
      "https://assets.imglab-cdn.net/image.jpeg?width=500&height=600&signature=MX0DlvzVo39-_Dh_YqPbOnrayWVabIWaSDzi-9PfGHQ"

  The `signature` query string will be automatically added to the URL.

  > Note: `secure_key` and `secure_salt` parameters are secrets that should not be added to the code. Please use environment vars or other secure method to use them in your project.

  ## Path

  The second parameter must be a `string` defining the path to the resource.

      iex> Imglab.url("assets", "path/to/myimage.jpeg", width: 500, height: 600)
      "https://assets.imglab-cdn.net/path/to/myimage.jpeg?width=500&height=600"

  ## Params

  The third optional parameter is a `keyword` list with any desired imglab transformation parameter.

  Some imglab parameters use hyphens inside their names. You can use atoms with underscores, these will be normalized to the correct format used by imglab API.

      iex> Imglab.url("assets", "image.jpeg", width: 500, trim: "color", trim_color: "orange")
      "https://assets.imglab-cdn.net/image.jpeg?width=500&trim=color&trim-color=orange"

  Or you can define a quoted atom instead:

      iex> Imglab.url("assets", "image.jpeg", width: 500, trim: "color", "trim-color": "orange")
      "https://assets.imglab-cdn.net/image.jpeg?width=500&trim=color&trim-color=orange"

  If no params are specified a URL without query params will be generated:

      iex> Imglab.url("assets", "image.jpeg")
      "https://assets.imglab-cdn.net/image.jpeg"

  """
  @spec url(binary | Source.t(), binary, keyword) :: binary
  def url(source_name_or_source, path, params \\ [])

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
      |> Enum.map(&encode_path_component/1)
      |> Enum.join("/")
    end
  end

  @spec encode_path_component(binary) :: binary
  defp encode_path_component(path_component) when is_binary(path_component) do
    URI.encode(path_component, &URI.char_unreserved?/1)
  end

  @spec encode_params(Source.t(), binary, list) :: binary
  defp encode_params(%Source{} = source, path, params)
       when is_binary(path) and is_list(params) and length(params) > 0 do
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
