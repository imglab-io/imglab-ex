defmodule Imglab.Color do
  @moduledoc """
  Provides a set of macros to specify color parameter values.
  """

  @colors ~w(
    aliceblue
    antiquewhite
    aqua
    aquamarine
    azure
    beige
    bisque
    black
    blanchedalmond
    blue
    blueviolet
    brown
    burlywood
    cadetblue
    chartreuse
    chocolate
    coral
    cornflowerblue
    cornsilk
    crimson
    cyan
    darkblue
    darkcyan
    darkgoldenrod
    darkgray
    darkgreen
    darkgrey
    darkkhaki
    darkmagenta
    darkolivegreen
    darkorange
    darkorchid
    darkred
    darksalmon
    darkseagreen
    darkslateblue
    darkslategray
    darkslategrey
    darkturquoise
    darkviolet
    deeppink
    deepskyblue
    dimgray
    dimgrey
    dodgerblue
    firebrick
    floralwhite
    forestgreen
    fuchsia
    gainsboro
    ghostwhite
    gold
    goldenrod
    gray
    green
    greenyellow
    grey
    honeydew
    hotpink
    indianred
    indigo
    ivory
    khaki
    lavender
    lavenderblush
    lawngreen
    lemonchiffon
    lightblue
    lightcoral
    lightcyan
    lightgoldenrodyellow
    lightgray
    lightgreen
    lightgrey
    lightpink
    lightsalmon
    lightseagreen
    lightskyblue
    lightslategray
    lightslategrey
    lightsteelblue
    lightyellow
    lime
    limegreen
    linen
    magenta
    maroon
    mediumaquamarine
    mediumblue
    mediumorchid
    mediumpurple
    mediumseagreen
    mediumslateblue
    mediumspringgreen
    mediumturquoise
    mediumvioletred
    midnightblue
    mintcream
    mistyrose
    moccasin
    navajowhite
    navy
    oldlace
    olive
    olivedrab
    orange
    orangered
    orchid
    palegoldenrod
    palegreen
    paleturquoise
    palevioletred
    papayawhip
    peachpuff
    peru
    pink
    plum
    powderblue
    purple
    rebeccapurple
    red
    rosybrown
    royalblue
    saddlebrown
    salmon
    sandybrown
    seagreen
    seashell
    sienna
    silver
    skyblue
    slateblue
    slategray
    slategrey
    snow
    springgreen
    steelblue
    tan
    teal
    thistle
    tomato
    turquoise
    violet
    wheat
    white
    whitesmoke
    yellow
    yellowgreen
  )

  defguardp is_component(component) when is_integer(component) and component >= 0 and component <= 255

  @doc """
  Returns a RGBA color as string.

  ## Examples

      iex> Imglab.Color.color(128, 128, 128, 128)
      "128,128,128,128"

      iex> Imglab.Color.color(255, 128, 128, 50)
      "255,128,128,50"

      iex> Imglab.Color.color(255, 128, 0, 0)
      "255,128,0,0"

  """
  @spec color(integer, integer, integer, integer) :: binary
  defmacro color(r, g, b, a) when is_component(r) and is_component(g) and is_component(b) and is_component(a) do
    Enum.join([r, g, b, a], ",")
  end

  @doc """
  Returns a RGB color as string.

  ## Examples

      iex> Imglab.Color.color(128, 128, 128)
      "128,128,128"

      iex> Imglab.Color.color(255, 128, 50)
      "255,128,50"

      iex> Imglab.Color.color(255, 0, 0)
      "255,0,0"

  """
  @spec color(integer, integer, integer) :: binary
  defmacro color(r, g, b) when is_component(r) and is_component(g) and is_component(b) do
    Enum.join([r, g, b], ",")
  end

  @doc """
  Returns a named color as string. Useful to use a named color checking possible typos.

  ## Examples

      iex> Imglab.Color.color("blue")
      "blue"

      iex> Imglab.Color.color("green")
      "green"

      iex> Imglab.Color.color("white")
      "white"

  """
  @spec color(binary) :: binary
  defmacro color(name) when is_binary(name) and name in @colors do
    name
  end
end
