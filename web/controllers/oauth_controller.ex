defmodule Lift.OAuthController do
  use Lift.Web, :controller

  alias Lift.{User, Auth, Google}

  # Google
  defp fetch_body!("google", client) do
    OAuth2.Client.get!(client, "https://www.googleapis.com/plus/v1/people/me/openIdConnect")
    |> Map.fetch!(:body)
  end

  defp validate_token!("google", client) do
    Google.validate_token!(client)
  end

  defp fetch_token!("google", code) do
    Google.get_token!(code: code)
  end

  defp authorize_url!("google") do
    Google.authorize_url!(scope: "https://www.googleapis.com/auth/userinfo.email")
  end

  def index(conn, %{"provider" => provider}) do
    json conn, %{"url": authorize_url!(provider)}
  end

  def callback(conn, %{"provider" => provider, "code" => code}) do
    client = fetch_token!(provider, code)
    body = fetch_body!(provider, client)
    user = User.find_by_email(body["email"]) |> Repo.one

    cond do
      user && validate_token!(provider, client) ->
        json conn, %{jwt: Auth.generate_token(user)}
      true ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Invalid token, expired token, nonexisting email"})
    end
  end
end
