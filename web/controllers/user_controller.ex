defmodule Lift.UserController do
  use Lift.Web, :controller
  use Guardian.Phoenix.Controller

  alias Lift.{User, Category, CategoryView}

  plug Guardian.Plug.EnsureAuthenticated, [handler: Lift.TokenController]
    when action != :create

  def show(conn, _params, user, _claims) do
    user = Repo.preload(user, [:categories])
    render(conn, "authenticated_user.json", user: user)
  end

  def create(conn, user_params, _user, _claims) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render("authenticated_user.json", user: Repo.preload(user, [:categories]))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Lift.ChangesetView, "error.json", changeset: changeset)
    end
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
    changeset = User.changeset(user, user_params)

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
