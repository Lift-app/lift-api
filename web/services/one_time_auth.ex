defmodule Lift.OTA do
  alias Lift.RedixPool, as: Redix

  @namespace "ota_tokens"

  defp random_str(length \\ 32) do
    :crypto.strong_rand_bytes(length)
    |> Base.url_encode64
    |> binary_part(0, length)
  end

  def set_ota_token() do
    token = random_str()
    Redix.command(["SET", "#{@namespace}:#{token}", ""])
    token
  end

  def validate_ota_token(token \\ "") do
    case Redix.command(~w(EXISTS "#{@namespace}:#{token}")) do
      {:ok, 1} ->
        Redix.command(~w(DEL "#{@namespace}:#{token}"))
      _ ->
        {:error, "Token not found"}
    end
  end
end
