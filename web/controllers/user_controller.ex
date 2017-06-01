defmodule Lift.UserController do
  use Lift.Web, :controller
  use Guardian.Phoenix.Controller

  alias Lift.{User, Category}

  plug Guardian.Plug.EnsureAuthenticated, handler: Lift.TokenController

  def me(conn, _params, user, _claims) do
    user =
      User
      |> preload([:categories, :follower_users, :following_users, :profile_info])
      |> User.with_following(user.id)
      |> Repo.get!(user.id)
    render(conn, "authenticated_user.json", user: user)
  end

  def show(conn, %{"username" => username}, user, _claims) do
    user =
      User
      |> preload([:categories, :follower_users, :following_users, :profile_info])
      |> User.with_following(user.id)
      |> Repo.get_by!(username: username)

    render(conn, "profile.json", user: user)
  end

  def update(conn, user_params, user, _claims) do
    changeset =
      user
      |> Repo.preload([:profile_info])
      |> Ecto.Changeset.cast(user_params, [])
      |> Ecto.Changeset.cast_assoc(:profile_info)

    case Repo.update(changeset) do
      {:ok, _user} ->
        send_resp(conn, :no_content, "")
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Lift.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def onboarded(conn, _params, user, _claims) do
    changeset = Ecto.Changeset.change(user, onboarded: true)

    case Repo.update(changeset) do
      {:ok, _user} ->
        conn
        |> send_resp(:no_content, "")
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Lift.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
