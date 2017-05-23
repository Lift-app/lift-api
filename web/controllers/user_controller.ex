defmodule Lift.UserController do
  use Lift.Web, :controller
  use Guardian.Phoenix.Controller

  alias Lift.{User, Category}

  plug Guardian.Plug.EnsureAuthenticated, handler: Lift.TokenController

  def me(conn, _params, user, _claims) do
    user = Repo.preload(user, [:categories])
    render(conn, "authenticated_user.json", user: user)
  end

  def show(conn, %{"id" => id}, user, _claims) do
    user =
      User
      |> preload([:categories, :follows, :profile_info])
      |> User.with_following(user.id)
      |> Repo.get!(id)

    render(conn, "profile.json", user: user)
  end

  def update(conn, user_params, user, _claims) do
    user = Repo.preload(user, [:profile_info, :categories])
    changeset =
      cond do
        user_params["profile"] && user_params["interests"] ->
          categories = Category |> where([c], c.id in ^user_params["interests"]) |> Repo.all

          User.changeset(user, user_params)
          |> Ecto.Changeset.cast_assoc(:profile_info, user_params["profile"])
          |> Ecto.Changeset.cast_assoc(:categories, categories)
        user_params["profile"] ->
          User.changeset(user, user_params)
          |> Ecto.Changeset.cast_assoc(:profile_info, user_params["profile"])
        user_params["interests"] ->
          categories = Category |> where([c], c.id in ^user_params["interests"]) |> Repo.all

          User.changeset(user, user_params)
          |> Ecto.Changeset.put_assoc(:categories, categories)
        :otherwise ->
          User.changeset(user, user_params)
      end

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
