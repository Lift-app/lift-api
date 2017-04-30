defmodule Lift.InterestControllerTest do
  use Lift.ConnCase

  setup do
    {:ok, conn: build_conn()}
  end

  test "GET /user/:user_id/interests renders a list of interests", %{conn: conn} do
    user = insert(:user)

    conn = get(conn, interest_path(conn, :show, user.id))

    assert json_response(conn, 200) == render_json("index.json", categories: user.categories)
  end

  test "PUT /user/:user_id/interests/:interest_ids updates interests", %{conn: conn} do
    user = insert(:user)

    categories = insert_list(3, :category)
    category_ids = categories |> Enum.map(&(&1.id)) |> Enum.join(",")

    conn = put(conn, interest_path(conn, :update, user.id), %{"interest_ids" => category_ids})

    assert json_response(conn, 200)
  end

  defp render_json(template, assigns), do: render_json(Lift.CategoryView,  template, assigns)
end
