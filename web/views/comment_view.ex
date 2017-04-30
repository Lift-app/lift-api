defmodule Lift.CommentView do
  use Lift.Web, :view

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, Lift.CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, Lift.CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    user = if comment.deleted or comment.anonymous,
      do: nil,
      else: render_one(comment.user, Lift.UserView, "user.json")
    body = if comment.deleted, do: nil, else: comment.body

    %{
      id: comment.id,
      post_id: comment.post_id,
      parent_id: comment.parent_id,
      user: user,
      body: body,
      deleted: comment.deleted,
      anonymous: comment.anonymous,
      likes: comment.like_count,

      created_at: comment.inserted_at,
      updated_at: comment.updated_at
    }
  end
end
