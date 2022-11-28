defmodule Imglab.Sequence do
  @moduledoc """
  Provides a set of functions to specify integer number sequences.
  """

  @default_size 16

  @doc false
  def _default_size, do: @default_size

  @doc """
  Returns a geometric sequence of integer numbers inside an interval and with specific size as list.

  ## Examples

      iex> Imglab.Sequence.sequence(100, 8192)
      [100, 134, 180, 241, 324, 434, 583, 781, 1048, 1406, 1886, 2530, 3394, 4553, 6107, 8192]

      iex> Imglab.Sequence.sequence(100, 8192, 1)
      [100]

      iex> Imglab.Sequence.sequence(100, 8192, 2)
      [100, 8192]

      iex> Imglab.Sequence.sequence(100, 8192, 4)
      [100, 434, 1886, 8192]

      iex> Imglab.Sequence.sequence(70, 60, 6)
      [70, 68, 66, 64, 62, 60]

  """
  @spec sequence(integer, integer, integer) :: list
  def sequence(first, last, size \\ @default_size)

  def sequence(first, last, size)
      when is_integer(first) and is_integer(last) and is_integer(size) and size <= 0,
      do: []

  def sequence(first, last, size)
      when is_integer(first) and is_integer(last) and is_integer(size) and size == 1,
      do: [first]

  def sequence(first, last, size)
      when is_integer(first) and is_integer(last) and is_integer(size) and size == 2,
      do: [first, last]

  def sequence(first, last, size) when is_integer(first) and is_integer(last) and is_integer(size) do
    ratio = :math.pow(last / first, 1 / (size - 1))

    first
    |> Stream.iterate(&(&1 * ratio))
    |> Stream.map(&round(&1))
    |> Enum.take(size - 1)
    |> Enum.concat([last])
  end
end
