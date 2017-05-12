defmodule Lift.CommentViewTest do
  use Lift.ConnCase, async: true

  import Lift.Factory
  import Lift.DateHelpers

  alias Lift.CommentView

  test "index.json" do
    comment = insert(:comment)

    rendered_comments = CommentView.render("index.json", comments: [comment])

    assert rendered_comments == %{
      data: [CommentView.render("comment.json", comment: comment)]
    }
  end

  test "show.json" do
    comment = insert(:comment)

    rendered_comment = CommentView.render("show.json", comment: comment)

    assert rendered_comment == %{
      data: CommentView.render("comment.json", comment: comment)
    }
  end

  test "comment.json" do
    comment = insert(:comment)

    rendered_comment = CommentView.render("comment.json", comment: comment)

    assert rendered_comment == %{
      id: comment.id,
      type: comment.type,
      post_id: comment.post_id,
      parent_id: comment.parent_id,
      user: %{
        id: comment.user.id,
        username: comment.user.username,
        avatar: nil
      },
      body: comment.body,
      deleted: comment.deleted,
      anonymous: comment.anonymous,
      like_count: comment.like_count,

      created_at: local_date(comment.inserted_at),
      updated_at: local_date(comment.updated_at)
    }
  end
end
