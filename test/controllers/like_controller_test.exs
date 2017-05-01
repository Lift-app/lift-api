defmodule Lift.LikeControllerTest do
  use Lift.ConnCase

  alias Lift.Auth

  setup do
    user = insert(:user)
    post = insert(:post, user: user)
    token = Auth.generate_token(user)
    conn = build_conn() |> put_req_header("authorization", "bearer " <> token)

    {:ok, conn: conn, user: user, post: post}
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
