defmodule Lift.UploadAuth do
  alias Lift.RedixPool, as: Redix

  @set_name "upload_tokens"

  def generate_unique_token do
    token = random_string()
    Redix.command(~w(SADD #{@set_name} #{token}))

    token
  end

  def verify_token(token \\ "") do
    case Redix.command(~w(SISMEMBER #{@set_name} #{token})) do
      {:ok, 1} ->
        Redix.command(~w(SREM #{@set_name} #{token}))
        :ok
      _ -> {:error, "Token not found"}
    end
  end

  defp random_string(length \\ 32) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
