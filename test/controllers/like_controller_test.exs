defmodule Lift.LikeControllerTest do
  use Lift.ConnCase

  setup do
    user = insert(:user)
    post = insert(:post, user: user)

    {:ok, conn: build_conn(), user: user, post: post}
  end

  test "PUT /posts/:id/like likes a post", %{conn: conn} = context do
    conn = put(conn, "/posts/#{context.post.id}/like", %{user_id: context.user.id})
    assert response(conn, 204)
  end

  test "PUT /posts/:id/unlike unlikes a post", %{conn: conn} = context do
    like = insert(:like, user: context.user, post: context.post)
    conn = put(conn, "/posts/#{like.post.id}/unlike", %{user_id: context.user.id})
    assert response(conn, 204)
  end
end
