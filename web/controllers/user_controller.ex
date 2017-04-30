defmodule Lift.UserController do
  use Lift.Web, :controller
  use Guardian.Phoenix.Controller

  plug Guardian.Plug.EnsureAuthenticated, handler: Lift.TokenController

  def show(conn, _params, user, _claims) do
    user = Repo.preload(user, [:categories])
    render(conn, "authenticated_user.json", user: user)
  end
end
