defmodule Lift.UserView do
  use Lift.Web, :view

  alias Lift.OTA

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Lift.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Lift.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      avatar: user_avatar(user)
    }
  end

  def render("authenticated_user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      interests: render_many(user.categories, Lift.CategoryView, "category.json"),
      avatar: user_avatar(user),
      onboarded: user.onboarded,

      created_at: user.inserted_at,
      updated_at: user.updated_at,
    }
  end

  def render("profile.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      following: user.following,
      interests: render_many(user.categories, Lift.CategoryView, "category.json"),
      avatar: user_avatar(user),
      follower_count: length(user.follower_users),
      following_count: length(user.following_users),
      profile: render_one(user.profile_info, Lift.ProfileInfoView, "info.json"),

      created_at: user.inserted_at
    }
  end

  defp user_avatar(%{avatar: nil}), do: nil
  defp user_avatar(user) do
    token = OTA.generate_media_token()
    url = "#{Lift.Endpoint.url}/media/avatars/#{user.id}?token=#{token}"

    %{
      original: url,
      thumbnail: "#{url}&thumb"
    }
  end
end
