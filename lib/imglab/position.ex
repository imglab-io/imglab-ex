defmodule Imglab.Position do
  @moduledoc """
  Provides a set of macros to specify position parameter values.
  """

  @horizontal ~w(left center right)
  @vertical ~w(top middle bottom)

  defguardp is_position(pos) when is_binary(pos) and (pos in @horizontal or pos in @vertical)
  defguardp is_horizontal_position(pos) when is_binary(pos) and pos in @horizontal
  defguardp is_vertical_position(pos) when is_binary(pos) and pos in @vertical

  @doc """
  Returns a position as string specified with horizontal and vertical values:

      iex> Imglab.Position.position("left", "bottom")
      "left,bottom"

      iex> Imglab.Position.position("center", "middle")
      "center,middle"

      iex> Imglab.Position.position("right", "top")
      "right,top"

  Or specified with vertical and horizontal values:

      iex> Imglab.Position.position("bottom", "left")
      "bottom,left"

      iex> Imglab.Position.position("middle", "center")
      "middle,center"

      iex> Imglab.Position.position("top", "right")
      "top,right"

  """
  @spec position(binary, binary) :: binary
  defmacro position(horizontal, vertical) when is_horizontal_position(horizontal) and is_vertical_position(vertical) do
    Enum.join([horizontal, vertical], ",")
  end

  defmacro position(vertical, horizontal) when is_vertical_position(vertical) and is_horizontal_position(horizontal) do
    Enum.join([vertical, horizontal], ",")
  end

  @doc """
  Returns a position as string.

  ## Examples

      iex> Imglab.Position.position("left")
      "left"

      iex> Imglab.Position.position("bottom")
      "bottom"

      iex> Imglab.Position.position("right")
      "right"

  """
  @spec position(binary) :: binary
  defmacro position(pos) when is_position(pos), do: pos
end
