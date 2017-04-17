defmodule Lift.CategoryControllerTest do
  use Lift.ConnCase

  setup do
    {:ok, conn: build_conn()}
  end

  test "#index renders a list of categories", %{conn: conn} do
    category = insert(:category)

    conn = get(conn, category_path(conn, :index))

    assert json_response(conn, 200) == render_json("index.json", categories: [category])
  end

  test "#show renders a single category", %{conn: conn} do
    category = insert(:category)

    conn = get(conn, category_path(conn, :show, category.id))

    assert json_response(conn, 200) == render_json("show.json", category: category)
  end

  test "#create creates a category", %{conn: conn} do
    category = params_with_assocs(:category)

    conn = post(conn, category_path(conn, :create, category))

    assert json_response(conn, 201)
  end

  test "#posts returns a list of posts filtered by category", %{conn: conn} do
    category = insert(:category)
    posts = insert_list(3, :post, category: category)

    conn = get(conn, "/categories/#{category.id}/posts")

    assert json_response(conn, 200) == render_json(Lift.PostView, "index.json", posts: posts)
  end

  defp render_json(template, assigns), do: render_json(Lift.CategoryView,  template, assigns)
end
