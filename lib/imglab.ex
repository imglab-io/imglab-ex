defmodule Imglab do
  @moduledoc """
  Provides a set of functions to work with imglab services.
  """

  alias Imglab.Url
  alias Imglab.Source

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
    Url.new(source, path, params) |> Url.to_string()
  end
end
