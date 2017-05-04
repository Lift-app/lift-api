defmodule Lift.PostView do
  use Lift.Web, :view

  alias Lift.UploadAuth

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, Lift.PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, Lift.PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    user = if post.anonymous, do: nil, else: render_one(post.user, Lift.UserView, "user.json")
    body =
      if post.type == :audio do
        token = UploadAuth.generate_unique_token()
        "#{Lift.Endpoint.url}/media/posts/#{post.id}?token=#{token}"
      else
        post.body
      end

    %{
      id: post.id,
      type: post.type,
      user: user,
      category: render_one(post.category, Lift.CategoryView, "category.json"),
      body: body,
      locked: post.locked,
      anonymous: post.anonymous,
      likes: post.like_count,

      created_at: post.inserted_at,
      updated_at: post.updated_at
    }
  end
end
