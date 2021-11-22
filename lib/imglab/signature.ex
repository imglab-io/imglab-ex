defmodule Imglab.Signature do
  @moduledoc false

  alias Imglab.Source

  @spec generate(Source.t(), binary, nil | binary) :: binary
  def generate(%Source{} = source, path, encoded_params \\ nil)
      when is_binary(path) and (is_binary(encoded_params) or is_nil(encoded_params)) do
    decoded_secure_key = Base.decode64!(source.secure_key)
    decoded_secure_salt = Base.decode64!(source.secure_salt)

    data = "#{decoded_secure_salt}/#{path}"
    data = if encoded_params, do: "#{data}?#{encoded_params}", else: data

    hmac(decoded_secure_key, data)
    |> Base.url_encode64(padding: false)
  end

  if Code.ensure_loaded(:crypto) && function_exported?(:crypto, :mac, 4) do
    @spec hmac(binary, binary) :: binary
    defp hmac(key, data) when is_binary(key) and is_binary(data), do: :crypto.mac(:hmac, :sha256, key, data)
  else
    @spec hmac(binary, binary) :: binary
    defp hmac(key, data) when is_binary(key) and is_binary(data), do: :crypto.hmac(:sha256, key, data)
  end
end
