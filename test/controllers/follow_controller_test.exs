defmodule Lift.FollowControllerTest do
  use Lift.ConnCase

  setup do
    auth_user = insert(:user)
    {:ok, conn: authenticated_conn(auth_user), user: insert(:user),
     auth_user: auth_user}
  end

  test "routes require authentication" do
    conn = build_conn()

    assert put(conn, "/users/1/follow") |> json_response(401)
    assert put(conn, "/users/1/unfollow") |> json_response(401)
  end

  test "PUT /users/:id/follow follows a user", %{conn: conn} = context do
    conn = put(conn, "/users/#{context.user.id}/follow")
    assert response(conn, 204)
  end

  test "PUT /users/:id/unlike unlikes a post", %{conn: conn} = context do
    insert(
      :follow, user_follower: context.auth_user, user_following: context.user
    )

    conn = put(conn, "/users/#{context.user.id}/unfollow")
    assert response(conn, 204)
  end
end
