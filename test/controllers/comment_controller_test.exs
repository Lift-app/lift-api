defmodule Lift.CommentControllerTest do
  use Lift.ConnCase

  setup do
    {:ok, conn: build_conn()}
  end

  test "#index renders a list of comments", %{conn: conn} do
    comment = insert(:comment)

    conn = get(conn, comment_path(conn, :index, comment.post_id))

    assert json_response(conn, 200) == render_json("index.json", comments: [comment])
  end

  test "#show renders a single comment", %{conn: conn} do
    comment = insert(:comment)

    conn = get(conn, comment_path(conn, :show, comment.id))

    assert json_response(conn, 200) == render_json("show.json", comment: comment)
  end

  test "#create creates a comment", %{conn: conn} do
    comment = params_with_assocs(:comment)

    conn = post(conn, comment_path(conn, :create, comment))

    assert json_response(conn, 201)
  end

  defp render_json(template, assigns), do: render_json(Lift.CommentView,  template, assigns)
end
