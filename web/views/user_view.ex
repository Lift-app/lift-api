defmodule Lift.UserView do
  use Lift.Web, :view

  alias Lift.UploadAuth

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Lift.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Lift.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    Map.take(user, [:id, :username])
  end

  def render("authenticated_user.json", %{user: user}) do
    avatar =
      if user.avatar do
        token = UploadAuth.generate_unique_token()
        url = "#{Lift.Endpoint.url}/media/avatars/#{user.id}?token=#{token}"

        %{
          original: url,
          thumbnail: "#{url}&thumb"
        }
      else
        nil
      end

    %{
      id: user.id,
      username: user.username,
      email: user.email,
      interests: render_many(user.categories, Lift.CategoryView, "category.json"),
      avatar: avatar,

      created_at: user.inserted_at,
      updated_at: user.updated_at,
    }
  end
end
