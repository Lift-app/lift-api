defmodule Lift.CategoryController do
  use Lift.Web, :controller
  import Ecto.Query

  alias Lift.{Category, Post, PostView}

  def posts(conn, %{"category_ids" => category_ids}) do
    categories = String.split(category_ids, ",")

    posts =
      Post
      |> where([p], p.category_id in ^categories)
      |> Repo.all
      |> Repo.preload([:category, :user])

    render(conn, PostView, "index.json", posts: posts)
  end
end
