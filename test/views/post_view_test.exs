defmodule Lift.PostViewTest do
  use Lift.ConnCase, async: true

  import Lift.Factory

  alias Lift.PostView

  test "index.json" do
    post = insert(:post)

    rendered_posts = PostView.render("index.json", posts: [post])

    assert rendered_posts == %{
      data: [PostView.render("post.json", post: post)]
    }
  end

  test "show.json" do
    post = insert(:post)

    rendered_post = PostView.render("show.json", post: post)

    assert rendered_post == %{
      data: PostView.render("post.json", post: post)
    }
  end

  test "post.json" do
    post = insert(:post)

    rendered_post = PostView.render("post.json", post: post)

    assert rendered_post == %{
      id: post.id,
      body: post.body,
      locked: post.locked,
      category: %{
        id: post.category.id,
        name: post.category.name,
        description: post.category.description
      },
      user: %{ id: post.user.id, username: post.user.username },
      created_at: post.inserted_at,
      updated_at: post.updated_at
    }
  end
end
