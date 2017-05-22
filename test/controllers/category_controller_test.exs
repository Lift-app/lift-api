defmodule Lift.CategoryControllerTest do
  use Lift.ConnCase

  setup do
    {:ok, conn: authenticated_conn()}
  end

  test "routes require authentication" do
    conn = build_conn()

    assert get(conn, category_path(conn, :index)) |> json_response(401)
    assert get(conn, category_path(conn, :show, 1)) |> json_response(401)
    assert post(conn, category_path(conn, :create, %{})) |> json_response(401)
    assert get(conn, "/categories/1/posts") |> json_response(401)
  end

  test "GET /categories renders a list of categories", %{conn: conn} do
    category = insert(:category)

    conn = get(conn, category_path(conn, :index))

    assert json_response(conn, 200) == render_json("index.json", categories: [category])
  end

  test "GET /categories/:id renders a single category", %{conn: conn} do
    category = insert(:category)

    conn = get(conn, category_path(conn, :show, category.name))

    assert json_response(conn, 200) == render_json("show.json", category: category)
  end

  test "POST /categories creates a category", %{conn: conn} do
    category = params_with_assocs(:category)

    conn = post(conn, category_path(conn, :create, category))

    assert json_response(conn, 201)
  end

  test "GET /categories/:id/posts returns a list of posts filtered by category", %{conn: conn} do
    category = insert(:category)
    post = insert(:post, category: category)

    conn = get(conn, "/categories/#{category.id}/posts")

    assert json_response(conn, 200) == render_json(Lift.PostView, "index.json", posts: [post])
  end

  defp render_json(template, assigns), do: render_json(Lift.CategoryView,  template, assigns)
end
