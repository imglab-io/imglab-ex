defmodule Imglab.Url.Utils do
  @moduledoc false

  @web_uri_schemes ~w[https http]

  @spec normalize_path(binary) :: binary
  def normalize_path(path) when is_binary(path) do
    String.trim(path, "/")
  end

  @spec normalize_params(keyword) :: list
  def normalize_params(params) when is_list(params) do
    Enum.map(params, fn {key, value} ->
      normalize_param(dasherize(key), value)
    end)
  end

  @spec web_uri?(binary) :: boolean
  def web_uri?(uri) when is_binary(uri) do
    URI.parse(uri).scheme in @web_uri_schemes
  end

  @spec dasherize(atom | binary) :: binary
  defp dasherize(atom) when is_atom(atom), do: dasherize(Atom.to_string(atom))
  defp dasherize(string) when is_binary(string), do: String.replace(string, "_", "-")

  @spec normalize_param(binary, any) :: tuple
  defp normalize_param("expires" = key, %DateTime{} = value), do: {key, DateTime.to_unix(value)}
  defp normalize_param(key, value), do: {key, value}
end
