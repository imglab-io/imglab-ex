defmodule Imglab.Position do
  @moduledoc """
  Provides a set of macros to specify position parameter values.
  """

  @horizontal ~w(left center right)
  @vertical ~w(top middle bottom)

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
  defmacro position(horizontal, vertical)
  when
    is_binary(horizontal) and horizontal in @horizontal and
    is_binary(vertical) and vertical in @vertical
  do
    Enum.join([horizontal, vertical], ",")
  end

  defmacro position(vertical, horizontal)
  when
    is_binary(vertical) and vertical in @vertical and
    is_binary(horizontal) and horizontal in @horizontal
  do
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
  defmacro position(pos) when is_binary(pos) and (pos in @horizontal or pos in @vertical), do: pos
end
