defmodule Lift.PostControllerTest do
  use Lift.ConnCase

  setup do
    {:ok, conn: build_conn()}
  end

  test "#index renders a list of posts", %{conn: conn} do
    post = insert(:post)

    conn = get(conn, post_path(conn, :index))

    assert json_response(conn, 200) == render_json("index.json", posts: [post])
  end

  test "#show renders a single post", %{conn: conn} do
    post = insert(:post)

    conn = get(conn, post_path(conn, :show, post.id))

    assert json_response(conn, 200) == render_json("show.json", post: post)
  end

  test "#create creates a post", %{conn: conn} do
    post = params_with_assocs(:post)

    conn = post(conn, post_path(conn, :create, post))

    assert json_response(conn, 201)
  end

  defp render_json(template, assigns), do: render_json(Lift.PostView,  template, assigns)
end
