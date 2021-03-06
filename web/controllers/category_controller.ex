defmodule Lift.CategoryController do
  use Lift.Web, :controller

  alias Lift.{Category, Post, PostView}

  plug Guardian.Plug.EnsureAuthenticated, handler: Lift.TokenController

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    categories =
      Category
      |> preload(:posts)
      |> Category.with_is_interested(user.id)
      |> Repo.all
    render(conn, "index.json", categories: categories)
  end

  def create(conn, post_params) do
    changeset = Category.changeset(%Category{}, post_params)

    case Repo.insert(changeset) do
      {:ok, category} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", post_path(conn, :show, category))
        |> render("show.json", category: category)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Lift.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"name" => name}) do
    user = Guardian.Plug.current_resource(conn)
    category =
      from(c in Category, where: ilike(c.name, ^name))
      |> preload(:posts)
      |> Category.with_is_interested(user.id)
      |> Repo.one!

    render(conn, "show.json", category: category)
  end

  def posts(conn, %{"category_ids" => category_ids} = params) do
    user = Guardian.Plug.current_resource(conn)
    categories = String.split(category_ids, ",")

    posts =
      Post
      |> Post.ordered
      |> Post.with_associations
      |> Post.with_liked(user.id)
      |> where([p], p.category_id in ^categories)
      |> Repo.paginate(params)

    render(conn, PostView, "index.json", posts: posts)
  end
end
