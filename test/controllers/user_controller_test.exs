defmodule Lift.UserControllerTest do
  use Lift.ConnCase

  alias Lift.Auth

  setup do
    token = Auth.generate_token(insert(:user))
    conn = build_conn() |> put_req_header("authorization", "bearer " <> token)

    {:ok, conn: conn}
  end

  test "PUT /user/interests/:interest_ids updates interests", %{conn: conn} do
    categories = insert_list(3, :category)
    category_ids = categories |> Enum.map(&(&1.id)) |> Enum.join(",")

    conn = put(conn, "/user/interests", %{"interest_ids" => category_ids})

    assert json_response(conn, 200)
  end
end
