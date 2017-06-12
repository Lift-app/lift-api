defmodule Lift.PostViewTest do
  use Lift.ConnCase, async: true

  import Lift.Factory
  import Lift.DateHelpers

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
      type: post.type,
      body: post.body,
      locked: post.locked,
      like_count: length(post.likes),
      comment_count: length(post.comments),
      liked: post.liked,
      anonymous: post.anonymous,
      category: %{
        id: post.category.id,
        name: post.category.name,
        description: post.category.description,
        post_count: post.category.post_count,
        is_interested: false
      },
      user: %{
        id: post.user.id,
        username: post.user.username,
        avatar: nil
      },

      created_at: local_date(post.inserted_at),
      updated_at: local_date(post.updated_at)
    }
  end
end
