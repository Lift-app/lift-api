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

    rendered_posts = PostView.render("show.json", post: post)

    assert rendered_posts == %{
      data: PostView.render("post.json", post: post)
    }
  end
end
