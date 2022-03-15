defmodule Imglab.Utils do
  @moduledoc false

  @web_uri_schemes ~w[https http]

  @spec normalize_path(binary) :: binary
  def normalize_path(path) when is_binary(path) do
    String.trim(path, "/")
  end

  @spec normalize_params(list) :: list
  def normalize_params(params) when is_list(params) do
    Enum.map(params, fn {key, value} ->
      {dasherize(key), value}
    end)
  end

  @spec web_uri?(binary) :: boolean
  def web_uri?(uri) when is_binary(uri) do
    URI.parse(uri).scheme in @web_uri_schemes
  end

  @spec dasherize(atom | binary) :: binary
  defp dasherize(atom) when is_atom(atom), do: dasherize(Atom.to_string(atom))
  defp dasherize(string) when is_binary(string), do: String.replace(string, "_", "-")
end
