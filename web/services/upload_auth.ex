defmodule Lift.UploadAuth do
  alias Lift.RedixPool, as: Redix

  @namespace "upload_tokens"

  def generate_unique_token do
    token = random_string()
    Redix.command(["SET", "#{@namespace}:#{token}", "", "EX", 3600])

    token
  end

  def verify_token(token \\ "") do
    case Redix.command(~w(EXISTS #{@namespace}:#{token})) do
      {:ok, 1} ->
        Redix.command(~w(DEL #{@namespace}:#{token}))
        :ok
      _ -> {:error, "Token not found"}
    end
  end

  defp random_string(length \\ 32) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
  end
end
