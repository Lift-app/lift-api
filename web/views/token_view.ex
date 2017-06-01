defmodule Lift.TokenView do
  use Lift.Web, :view

  def render("login_user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      jwt: user.jwt,
    }
  end
end
