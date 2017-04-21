defmodule Lift.LikeControllerTest do
  use Lift.ConnCase

  setup do
    user = insert(:user)
    post = insert(:post)
    like = insert(:like, post: post)
    {:ok,
      conn: build_conn(),
      user: user,
      post: post,
      like: like}
  end

  describe "Lift.LikeController.like/2" do
    test "PUT /posts/:id/like likes a post", %{conn: conn} = context do
      conn = put(conn, "/posts/#{context.post.id}/like", %{user_id: context.user.id})
      assert response(conn, 204)
    end
  end

  describe "Lift.LikeController.unlike/2" do
    test "PUT /posts/:id/unlike unlikes a post", %{conn: conn} = context do
      conn = put(conn, "/posts/#{context.like.post.id}/unlike", %{user_id: context.user.id})
      assert response(conn, 204)
    end
  end
end
