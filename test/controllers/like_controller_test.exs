defmodule Lift.LikeControllerTest do
  use Lift.ConnCase

  setup do
    {:ok, conn: build_conn()}
  end

  test "PUT /posts/:id/like likes a post", %{conn: conn} do
    user = insert(:user)
    post = insert(:post)

    conn = put(conn, "/posts/#{post.id}/like", %{user_id: user.id})

    assert response(conn, 204)
  end

  test "PUT /posts/:id/unlike unlikes a post", %{conn: conn} do
    user = insert(:user)
    like = insert(:like, post: build(:post))

    conn = put(conn, "/posts/#{like.post.id}/unlike", %{user_id: user.id})

    assert response(conn, 204)
  end
end
