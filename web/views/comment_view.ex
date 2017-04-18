defmodule Lift.CommentView do
  use Lift.Web, :view

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, Lift.CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, Lift.CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      post_id: comment.post_id,
      user: render_one(comment.user, Lift.UserView, "user.json"),
      body: comment.body,

      created_at: comment.inserted_at,
      updated_at: comment.updated_at
    }
  end
end
