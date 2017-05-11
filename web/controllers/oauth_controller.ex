defmodule Lift.OAuthController do
  use Lift.Web, :controller

  alias Lift.{User, Auth, Google}

  # Private
  defp fetch_user(body) do
    Repo.get_by(User, email: body["email"])
  end

  defp populate_user!(user) do
    username =
      fn length ->
        :crypto.strong_rand_bytes(length)
        |> Base.encode32
        |> binary_part(0, length)
        |> String.downcase
      end
    user
    |> User.oauth_changeset()
    |> Ecto.Changeset.change(%{username: username.(8)})
    |> Repo.update!
  end

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
    redirect conn, external: authorize_url!(provider)
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  def callback(conn, %{"provider" => provider, "code" => code}) do
    client = fetch_token!(provider, code)
    body = fetch_body!(provider, client)
    user = fetch_user(body)
    user =
      case user do
        %User{username: nil} ->
          populate_user!(user)
        %User{} ->
          user
        nil ->
          nil
      end
    cond do
      user && validate_token!(provider, client) ->
        conn
        |> put_status(:ok)
        |> json(%{jwt: Auth.generate_token(user)})
      true ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Invalid token, expired token, nonexisting email"})
    end
  end
end
