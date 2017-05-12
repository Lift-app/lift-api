defmodule Lift.CommentView do
  use Lift.Web, :view

  import Lift.DateHelpers

  alias Lift.UploadAuth

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
    body =
      cond do
        comment.deleted ->
          nil
        comment.type == :audio ->
          token = UploadAuth.generate_unique_token()
          "#{Lift.Endpoint.url}/media/comments/#{comment.id}?token=#{token}"
        :otherwise ->
          comment.body
      end

    %{
      id: comment.id,
      liked: comment.liked,
      type: comment.type,
      post_id: comment.post_id,
      parent_id: comment.parent_id,
      user: user,
      body: body,
      deleted: comment.deleted,
      anonymous: comment.anonymous,
      like_count: comment.like_count,

      created_at: local_date(comment.inserted_at),
      updated_at: local_date(comment.updated_at)
    }
  end
end
