defmodule Lift.UserControllerTest do
  use Lift.ConnCase

  setup do
    {:ok, conn: authenticated_conn()}
  end

  test "routes require authentication" do
    conn = build_conn()

    assert get(conn, "/users/me") |> json_response(401)
    assert put(conn, "/users/me/interests", %{}) |> json_response(401)
  end

  test "PUT /users/me/interests/:interest_ids updates interests", %{conn: conn} do
    categories = insert_list(3, :category)
    category_ids = categories |> Enum.map(&(&1.id)) |> Enum.join(",")

    conn = put(conn, "/users/me/interests", %{"interest_ids" => category_ids})

    assert json_response(conn, 200)
  end
end
