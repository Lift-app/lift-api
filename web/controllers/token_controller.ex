defmodule Lift.TokenController do
  use Lift.Web, :controller

  alias Lift.Auth

  def unauthenticated(conn, _params) do
    conn
    |> put_status(:unauthorized)
    |> json(%{message: "Authorization required"})
    |> halt
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case Auth.verify(email, password) do
      {:ok, user} ->
        jwt = Auth.generate_token(user)
        render(conn, "login_user.json", user: Map.put(user, :jwt, jwt))
      {:error, _reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{message: "Invalid login"})
    end
  end

  def delete(conn, _params) do
    jwt = Guardian.Plug.current_token(conn)
    {:ok, claims} = Guardian.Plug.claims(conn)

    Guardian.revoke!(jwt, claims)

    send_resp(conn, :no_content, "")
  end
end
