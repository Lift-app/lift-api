defmodule Lift.CommentControllerTest do
  use Lift.ConnCase

  setup do
    {:ok, conn: authenticated_conn()}
  end

  test "GET /posts/:id/comments renders a post's comments", %{conn: conn} do
    comment = insert(:comment)

    conn = get(conn, comment_path(conn, :index, comment.post.id))

    assert json_response(conn, 200) == render_json("index.json", comments: [comment])
  end

  test "POST /comments creates a comment", %{conn: conn} do
    comment = params_with_assocs(:comment)

    conn = post(conn, comment_path(conn, :create, comment))

    assert json_response(conn, 201)
  end

  test "DELETE /comments/:id soft deletes a comment", %{conn: conn} do
    comment = insert(:comment)

    conn = delete(conn, comment_path(conn, :delete, comment.id))

    assert response(conn, 204)
  end

  test "deleted post doesn't show user and body", %{conn: conn} do
    comment = insert(:comment, deleted: true)

    conn = get(conn, comment_path(conn, :show, comment.id))

    response = json_response(conn, 200)

    assert response["data"]["user"] === nil
    assert response["data"]["body"] === nil
  end


  defp render_json(template, assigns), do: render_json(Lift.CommentView,  template, assigns)
end
