defmodule Lift.PostView do
  use Lift.Web, :view

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, Lift.PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, Lift.PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{
      id: post.id,
      user: post.user.username,
      category: post.category.name,
      body: post.body,
      is_locked: post.is_locked,

      created_at: post.inserted_at,
      updated_at: post.updated_at
    }
  end
end
