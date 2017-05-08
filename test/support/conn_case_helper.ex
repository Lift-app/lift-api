defmodule Lift.ConnCaseHelper do
  use Phoenix.ConnTest

  import Lift.Factory

  alias Lift.Auth

  def authenticated_conn(user \\ nil) do
    user = user || insert(:user)
    token = Auth.generate_token(user)
    build_conn() |> put_req_header("authorization", "bearer " <> token)
  end

  def render_json(view, template, assigns) do
    view.render(template, assigns) |> format_json
  end

  defp format_json(data) do
   data |> Poison.encode! |> Poison.decode!
 end
end
