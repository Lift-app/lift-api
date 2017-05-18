defmodule Lift.UserController do
  use Lift.Web, :controller
  use Guardian.Phoenix.Controller

  alias Lift.{User, Category, CategoryView}

  plug Guardian.Plug.EnsureAuthenticated, handler: Lift.TokenController

  def me(conn, _params, user, _claims) do
    user = Repo.preload(user, [:categories])
    render(conn, "authenticated_user.json", user: user)
  end

  def show(conn, %{"id" => id}, user, _claims) do
    user =
      User
      |> preload([:categories])
      |> User.with_following(user.id)
      |> Repo.get!(id)

    render(conn, "profile.json", user: user)
  end

  def update_interests(conn, %{"interest_ids" => interest_ids}, user, _claims) do
    user = Repo.preload(user, [:categories])
    interests = String.split(interest_ids, ",")
    categories = Category |> where([c], c.id in ^interests) |> Repo.all

    changeset =
      user
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_assoc(:categories, categories)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, CategoryView, "index.json", categories: user.categories)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Lift.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, user_params, user, _claims) do
    changeset = user |> User.changeset(user_params)

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
