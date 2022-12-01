defmodule Imglab do
  @moduledoc """
  Provides a set of functions to work with imglab services.
  """

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
  @spec url(binary | Imglab.Source.t(), binary, keyword) :: binary
  defdelegate url(source_name_or_source, path, params \\ []), to: Imglab.Url

  @doc """
  Returns a formatted srcset `string` with the specified parameters.

  This function expects the same parameters and values as `url/3` with the exception of some params that have a special meaning and can receive list, `Range` and `Imglab.Sequence` values.

  For more information about how to specify sources and paths take a look to `url/3` function.

  ## Fixed size

  When enough information is specified about the image output size (using `width` or `height` parameters) srcset function will generate URLs with a default number of dprs:

      iex> Imglab.srcset("assets", "image.jpeg", width: 500)
      "https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=1 1x,
      https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=2 2x,
      https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=3 3x,
      https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=4 4x,
      https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=5 5x,
      https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=6 6x"

  You can specify a `Range` value for `quality` parameter so you can increasingly reduce the final size of the image for big dprs:

      iex> Imglab.srcset("assets", "image.jpeg", width: 500, quality: 80..40)
      "https://assets.imglab-cdn.net/image.jpeg?width=500&quality=80&dpr=1 1x,
      https://assets.imglab-cdn.net/image.jpeg?width=500&quality=70&dpr=2 2x,
      https://assets.imglab-cdn.net/image.jpeg?width=500&quality=61&dpr=3 3x,
      https://assets.imglab-cdn.net/image.jpeg?width=500&quality=53&dpr=4 4x,
      https://assets.imglab-cdn.net/image.jpeg?width=500&quality=46&dpr=5 5x,
      https://assets.imglab-cdn.net/image.jpeg?width=500&quality=40&dpr=6 6x"

  If you prefer a different list of dprs you can specify them as a `Range` or explicit list of values:

      iex> Imglab.srcset("assets", "image.jpeg", width: 500, dpr: 1..3)
      "https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=1 1x,
      https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=2 2x,
      https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=3 3x"

      iex> Imglab.srcset("assets", "image.jpeg", width: 500, dpr: [1, 2, 3])
      "https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=1 1x,
      https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=2 2x,
      https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=3 3x"

  And even specify `Range` or list values for `quality` param:

      iex> Imglab.srcset("assets", "image.jpeg", width: 500, dpr: 1..3, quality: 80..40)
      "https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=1&quality=80 1x,
      https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=2&quality=57 2x,
      https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=3&quality=40 3x"

      iex> Imglab.srcset("assets", "image.jpeg", width: 500, dpr: [1, 2, 3], quality: [80, 70, 40])
      "https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=1&quality=80 1x,
      https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=2&quality=70 2x,
      https://assets.imglab-cdn.net/image.jpeg?width=500&dpr=3&quality=40 3x"

  ## Dynamic width

  It is possible to specify a dynamic `width` value using `Range`, lists or `Imglab.Sequence` values:

      iex> Imglab.srcset("assets", "image.jpeg", width: 300..1000)
      "https://assets.imglab-cdn.net/image.jpeg?width=300 300w,
      https://assets.imglab-cdn.net/image.jpeg?width=325 325w,
      https://assets.imglab-cdn.net/image.jpeg?width=352 352w,
      https://assets.imglab-cdn.net/image.jpeg?width=382 382w,
      https://assets.imglab-cdn.net/image.jpeg?width=414 414w,
      https://assets.imglab-cdn.net/image.jpeg?width=448 448w,
      https://assets.imglab-cdn.net/image.jpeg?width=486 486w,
      https://assets.imglab-cdn.net/image.jpeg?width=526 526w,
      https://assets.imglab-cdn.net/image.jpeg?width=570 570w,
      https://assets.imglab-cdn.net/image.jpeg?width=618 618w,
      https://assets.imglab-cdn.net/image.jpeg?width=669 669w,
      https://assets.imglab-cdn.net/image.jpeg?width=725 725w,
      https://assets.imglab-cdn.net/image.jpeg?width=786 786w,
      https://assets.imglab-cdn.net/image.jpeg?width=852 852w,
      https://assets.imglab-cdn.net/image.jpeg?width=923 923w,
      https://assets.imglab-cdn.net/image.jpeg?width=1000 1000w"

      iex> Imglab.srcset("assets", "image.jpeg", width: [300, 500, 1000])
      "https://assets.imglab-cdn.net/image.jpeg?width=300 300w,
      https://assets.imglab-cdn.net/image.jpeg?width=500 500w,
      https://assets.imglab-cdn.net/image.jpeg?width=1000 1000w"

      iex> Imglab.srcset("assets", "image.jpeg", width: Imglab.Sequence.sequence(300, 1000, 4))
      "https://assets.imglab-cdn.net/image.jpeg?width=300 300w,
      https://assets.imglab-cdn.net/image.jpeg?width=448 448w,
      https://assets.imglab-cdn.net/image.jpeg?width=669 669w,
      https://assets.imglab-cdn.net/image.jpeg?width=1000 1000w"

  When specifying a dynamic `width` value is also possible to specify `height` and `quality` dynamic values:

      iex> Imglab.srcset("assets", "image.jpeg", width: 300..1000, quality: 75..60)
      "https://assets.imglab-cdn.net/image.jpeg?width=300&quality=75 300w,
      https://assets.imglab-cdn.net/image.jpeg?width=325&quality=74 325w,
      https://assets.imglab-cdn.net/image.jpeg?width=352&quality=73 352w,
      https://assets.imglab-cdn.net/image.jpeg?width=382&quality=72 382w,
      https://assets.imglab-cdn.net/image.jpeg?width=414&quality=71 414w,
      https://assets.imglab-cdn.net/image.jpeg?width=448&quality=70 448w,
      https://assets.imglab-cdn.net/image.jpeg?width=486&quality=69 486w,
      https://assets.imglab-cdn.net/image.jpeg?width=526&quality=68 526w,
      https://assets.imglab-cdn.net/image.jpeg?width=570&quality=67 570w,
      https://assets.imglab-cdn.net/image.jpeg?width=618&quality=66 618w,
      https://assets.imglab-cdn.net/image.jpeg?width=669&quality=65 669w,
      https://assets.imglab-cdn.net/image.jpeg?width=725&quality=64 725w,
      https://assets.imglab-cdn.net/image.jpeg?width=786&quality=63 786w,
      https://assets.imglab-cdn.net/image.jpeg?width=852&quality=62 852w,
      https://assets.imglab-cdn.net/image.jpeg?width=923&quality=61 923w,
      https://assets.imglab-cdn.net/image.jpeg?width=1000&quality=60 1000w"

      iex> Imglab.srcset("assets", "image.jpeg", width: [300, 500, 1000], height: [400, 600, 700], quality: [75, 70, 65])
      "https://assets.imglab-cdn.net/image.jpeg?width=300&height=400&quality=75 300w,
      https://assets.imglab-cdn.net/image.jpeg?width=500&height=600&quality=70 500w,
      https://assets.imglab-cdn.net/image.jpeg?width=1000&height=700&quality=65 1000w"

  ## No size

  When information about the image output size is not specified a predefined sequence of widths will be used:

      iex> Imglab.srcset("assets", "image.jpeg")
      "https://assets.imglab-cdn.net/image.jpeg?width=100 100w,
      https://assets.imglab-cdn.net/image.jpeg?width=134 134w,
      https://assets.imglab-cdn.net/image.jpeg?width=180 180w,
      https://assets.imglab-cdn.net/image.jpeg?width=241 241w,
      https://assets.imglab-cdn.net/image.jpeg?width=324 324w,
      https://assets.imglab-cdn.net/image.jpeg?width=434 434w,
      https://assets.imglab-cdn.net/image.jpeg?width=583 583w,
      https://assets.imglab-cdn.net/image.jpeg?width=781 781w,
      https://assets.imglab-cdn.net/image.jpeg?width=1048 1048w,
      https://assets.imglab-cdn.net/image.jpeg?width=1406 1406w,
      https://assets.imglab-cdn.net/image.jpeg?width=1886 1886w,
      https://assets.imglab-cdn.net/image.jpeg?width=2530 2530w,
      https://assets.imglab-cdn.net/image.jpeg?width=3394 3394w,
      https://assets.imglab-cdn.net/image.jpeg?width=4553 4553w,
      https://assets.imglab-cdn.net/image.jpeg?width=6107 6107w,
      https://assets.imglab-cdn.net/image.jpeg?width=8192 8192w"

  """
  @spec srcset(binary | Imglab.Source.t(), binary, keyword) :: binary
  defdelegate srcset(source_name_or_source, path, params \\ []), to: Imglab.Srcset
end
