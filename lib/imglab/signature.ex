defmodule Imglab.Signature do
  @moduledoc false

  alias Imglab.Source

  defmacrop hmac(key, data) do
    if System.otp_release() >= "22" do
      quote do: :crypto.mac(:hmac, :sha256, unquote(key), unquote(data))
    else
      quote do: :crypto.hmac(:sha256, unquote(key), unquote(data))
    end
  end

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
end
