defmodule Lift.OAuthController do
  use Lift.Web, :controller

  alias Lift.{User, Auth, Google, Facebook}

  defp get_user!("google", client) do
    OAuth2.Client.get!(client, "https://www.googleapis.com/plus/v1/people/me/openIdConnect")
  end
  defp get_user!("facebook", client) do
    OAuth2.Client.get!(client, "/me", fields: "id")
  end

  defp get_token!("google", code), do: Google.get_token!(code: code)
  defp get_token!("facebook", code), do: Facebook.get_token!(code: code)

  defp authorize_url!("google"),
    do: Google.authorize_url!(scope: "https://www.googleapis.com/auth/userinfo.email")
  defp authorize_url!("facebook"),
    do: Facebook.authorize_url!(scope: "public_profile")

  defp find_oauth_user("google", %{"email" => email}) do
    User.find_by_email(email)
    |> where(oauth: true)
    |> Repo.one
  end
  defp find_oauth_user("facebook", %{"id" => id}) do
    Repo.one(from u in User, where: u.oauth == true and u.facebook_id == ^"#{id}")
  end

  def index(conn, %{"provider" => provider}) do
    json conn, %{"url": authorize_url!(provider)}
  end

  def callback(conn, %{"provider" => provider, "code" => code}) do
    client = get_token!(provider, code)
    body = get_user!(provider, client) |> Map.fetch!(:body)
    user = find_oauth_user(provider, body)

    if user do
      jwt = Auth.generate_token(user)
      render(conn, "login_user.json", user: Map.put(user, :jwt, jwt))
    else
      conn
      |> put_status(:unprocessable_entity)
      |> json(%{message: "User not found"})
    end
  end
end
