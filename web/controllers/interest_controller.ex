defmodule Lift.InterestController do
  use Lift.Web, :controller
  import Ecto.Query

  alias Lift.{User, Category, CategoryView}

  def show(conn, %{"user_id" => user_id}) do
    # TODO: get user_id from authenticated user
    user = Repo.get!(User, user_id)
    categories = Repo.all(assoc(user, :categories))

    render(conn, CategoryView, "index.json", categories: categories)
  end

  def update(conn, %{"user_id" => user_id, "interest_ids" => interest_ids}) do
    # TODO: get user_id from authenticated user
    user = Repo.get!(User, user_id) |> Repo.preload(:categories)
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
end
