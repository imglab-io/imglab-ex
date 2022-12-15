defmodule Imglab.Srcset do
  @moduledoc false

  alias Imglab.Url
  alias Imglab.Source
  alias Imglab.Sequence
  alias Imglab.Srcset.Utils

  @default_dprs [1, 2, 3, 4, 5, 6]
  @default_widths Sequence.sequence(100, 8192)

  @spec srcset(binary | Source.t(), binary, keyword) :: binary
  def srcset(source, path, params \\ [])

  def srcset(source_name, path, params) when is_binary(source_name) and is_binary(path) and is_list(params) do
    srcset(Source.new(source_name), path, params)
  end

  def srcset(%Source{} = source, path, params) when is_binary(path) and is_list(params) do
    params = Utils.normalize_params(params)

    [width, height, dpr] = [params[:width], params[:height], params[:dpr]]

    cond do
      is_dynamic?(width) ->
        if is_dynamic?(dpr) do
          raise(ArgumentError, message: "dpr as list or Range is not allowed when width is also a list or Range")
        end

        srcset_width(source, path, params)

      width || height ->
        if is_dynamic?(height) do
          raise(ArgumentError, message: "height as list or Range is only allowed when width is also a list or Range")
        end

        srcset_dpr(source, path, Utils.replace_or_append_params(params, :dpr, dprs(params)))

      true ->
        if is_dynamic?(dpr) do
          raise(ArgumentError, message: "dpr as list or Range is not allowed without specifying width or height")
        end

        srcset_width(source, path, Utils.replace_or_append_params(params, :width, @default_widths))
    end
  end

  @spec dprs(keyword) :: list
  defp dprs(params) when is_list(params) do
    if is_dynamic?(params[:dpr]) do
      params[:dpr]
    else
      @default_dprs
    end
  end

  @spec is_dynamic?(any) :: boolean
  defp is_dynamic?(value) when is_list(value), do: true
  defp is_dynamic?(%Range{}), do: true
  defp is_dynamic?(_value), do: false

  @spec srcset_dpr(Source.t(), binary, keyword) :: binary
  defp srcset_dpr(%Source{} = source, path, params) when is_binary(path) and is_list(params) do
    Enum.map_join(Utils.split_dpr(params), ",\n", fn split_params ->
      "#{Url.url(source, path, split_params)} #{Keyword.fetch!(split_params, :dpr)}x"
    end)
  end

  @spec srcset_width(Source.t(), binary, keyword) :: binary
  defp srcset_width(%Source{} = source, path, params) when is_binary(path) and is_list(params) do
    Enum.map_join(Utils.split_width(params), ",\n", fn split_params ->
      "#{Url.url(source, path, split_params)} #{Keyword.fetch!(split_params, :width)}w"
    end)
  end
end
