defmodule Imglab.Srcset.Utils do
  @moduledoc false

  alias Imglab.Sequence

  @normalize_keys ~w[dpr width]a

  @split_dpr_keys ~w[dpr quality]a
  @split_width_keys ~w[width height quality]a

  @spec normalize_params(keyword) :: keyword
  def normalize_params(params) when is_list(params) do
    Enum.reject(params, fn {key, value} -> key in @normalize_keys && value == [] end)
  end

  @spec replace_or_append_params(keyword, atom, any) :: keyword
  def replace_or_append_params(params, key, value) when is_list(params) and is_atom(key) do
    if Keyword.has_key?(params, key) do
      replace_params(params, key, value)
    else
      params ++ [{key, value}]
    end
  end

  @spec split_dpr(keyword) :: keyword
  def split_dpr(params) when is_list(params) do
    params
    |> split_values(@split_dpr_keys, Enum.count(Keyword.fetch!(params, :dpr)))
    |> Enum.map(fn {dpr, quality} ->
      params
      |> replace_params(:dpr, dpr)
      |> replace_params(:quality, quality)
    end)
  end

  @spec split_width(keyword) :: keyword
  def split_width(params) when is_list(params) do
    params
    |> split_values(@split_width_keys, split_size(Keyword.fetch!(params, :width)))
    |> Enum.map(fn {width, height, quality} ->
      params
      |> replace_params(:width, width)
      |> replace_params(:height, height)
      |> replace_params(:quality, quality)
    end)
  end

  @spec split_size(Range.t() | list) :: integer
  defp split_size(%Range{}), do: Sequence._default_size()
  defp split_size(value) when is_list(value), do: Enum.count(value)

  @spec split_values(keyword, list, integer) :: list
  defp split_values(params, keys, size) do
    keys
    |> Enum.map(&split_value(&1, Keyword.get(params, &1), size))
    |> Enum.zip()
  end

  @spec split_value(atom, any, integer) :: list
  defp split_value(:dpr, %Range{} = value, _size), do: Enum.to_list(value)
  defp split_value(_key, %Range{first: first, last: last}, size), do: Sequence.sequence(first, last, size)

  defp split_value(_key, value, size) when is_list(value) and length(value) < size do
    Enum.concat(value, Stream.repeatedly(fn -> nil end) |> Enum.take(size - length(value)))
  end

  defp split_value(_key, value, _size) when is_list(value), do: value
  defp split_value(_key, value, size), do: Stream.repeatedly(fn -> value end) |> Enum.take(size)

  @spec replace_params(keyword, atom, any) :: keyword
  defp replace_params(params, key, value) when is_list(params) and is_atom(key) do
    do_replace_params(params, key, value)
  end

  defp do_replace_params([{key, _} | params], key, value) do
    [{key, value} | Keyword.delete(params, key)]
  end

  defp do_replace_params([{_, _} = e | params], key, value) do
    [e | do_replace_params(params, key, value)]
  end

  defp do_replace_params([], _key, _value), do: []
end
