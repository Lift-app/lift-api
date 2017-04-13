defmodule Lift.UserView do
  use Lift.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Lift.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Lift.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      username: user.username,
      email: user.email,
      is_banned: user.is_banned,

      created_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end
end
