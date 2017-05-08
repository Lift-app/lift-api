defmodule Lift.LikeControllerTest do
  use Lift.ConnCase

  setup do
    user = insert(:user)
    post = insert(:post, user: user)

    {:ok, conn: authenticated_conn(user), user: user, post: post}
  end

  test "routes require authentication", context do
    conn = build_conn()

    assert put(conn, "/posts/#{context.post.id}/like") |> json_response(401)
    assert put(conn, "/posts/#{context.post.id}/unlike") |> json_response(401)
  end

  test "PUT /posts/:id/like likes a post", %{conn: conn} = context do
    conn = put(conn, "/posts/#{context.post.id}/like")
    assert response(conn, 204)
  end

  test "PUT /posts/:id/unlike unlikes a post", %{conn: conn} = context do
    like = insert(:like, user: context.user, post: context.post)
    conn = put(conn, "/posts/#{like.post.id}/unlike")
    assert response(conn, 204)
  end
end
