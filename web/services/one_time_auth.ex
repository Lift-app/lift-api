defmodule Lift.OTA do
  alias Lift.RedixPool, as: Redix

  def generate_media_token, do: generate_ota_token("media_tokens", 20)
  def verify_media_token(token), do: verify_ota_token("media_tokens", token)

  def generate_signup_token, do: generate_ota_token("signup_tokens")
  def verify_signup_token(token), do: verify_ota_token("signup_tokens", token)

  defp generate_ota_token(namespace, expiry \\ false) do
    token = random_string()

    if expiry do
      Redix.command(["SET", "#{namespace}:#{token}", "", "EX", expiry])
    else
      Redix.command(["SET", "#{namespace}:#{token}", ""])
    end

    token
  end

  defp verify_ota_token(namespace, token \\ "") do
    case Redix.command(~w(EXISTS "#{namespace}:#{token}")) do
      {:ok, 1} ->
        Redix.command(~w(DEL "#{namespace}:#{token}"))
      _ ->
        {:error, "Token not found"}
    end
  end

  defp random_string(length \\ 32) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64
    |> binary_part(0, length)
  end
end
