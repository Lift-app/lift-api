defmodule Lift.PostView do
  use Lift.Web, :view

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, Lift.PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, Lift.PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    user = if post.anonymous, do: nil, else: render_one(post.user, Lift.UserView, "user.json")

    %{
      id: post.id,
      user: user,
      category: render_one(post.category, Lift.CategoryView, "category.json"),
      body: post.body,
      locked: post.locked,
      anonymous: post.anonymous,
      # likes: post.likes,

      created_at: post.inserted_at,
      updated_at: post.updated_at
    }
  end
end
