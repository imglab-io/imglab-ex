defmodule Imglab.Srcset do
  @moduledoc false

  alias Imglab.Url
  alias Imglab.Source
  alias Imglab.Srcset.Utils

  @default_dprs [1, 2, 3, 4, 5, 6]
  @default_widths Imglab.Sequence.sequence(100, 8192)

  @spec srcset(binary | Source.t(), binary, keyword) :: binary
  def srcset(source_name_or_source, path, params \\ [])

  def srcset(source_name, path, params) when is_binary(source_name) and is_binary(path) and is_list(params) do
    srcset(Source.new(source_name), path, params)
  end

  def srcset(%Source{} = source, path, params) when is_binary(path) and is_list(params) do
    params = Utils.normalize_params(params)

    cond do
      Enumerable.impl_for(params[:width]) ->
        if Enumerable.impl_for(params[:dpr]) do
          raise(ArgumentError, message: "dpr as enumerable is not allowed when width is also an enumerable")
        end

        srcset_width(source, path, params)

      params[:width] || params[:height] ->
        if Enumerable.impl_for(params[:height]) do
          raise(ArgumentError, message: "height as enumerable is only allowed when width is also an enumerable")
        end

        dpr =
          if Enumerable.impl_for(params[:dpr]) do
            params[:dpr]
          else
            @default_dprs
          end

        srcset_dpr(source, path, Utils.replace_or_append_params(params, :dpr, dpr))

      true ->
        if Enumerable.impl_for(params[:dpr]) do
          raise(ArgumentError, message: "dpr as enumerable is not allowed without specifying width or height")
        end

        srcset_width(source, path, Utils.replace_or_append_params(params, :width, @default_widths))
    end
  end

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
