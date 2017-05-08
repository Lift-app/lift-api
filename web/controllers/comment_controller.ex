defmodule Lift.CommentController do
  use Lift.Web, :controller

  alias Lift.{Comment, Post}

  plug Guardian.Plug.EnsureAuthenticated, handler: Lift.TokenController

  def index(conn, %{"post_id" => post_id}) do
    post = Repo.get!(Post, post_id)
    comments =
      assoc(post, :comments)
      |> Comment.with_associations
      |> Comment.with_likes
      |> Repo.all

    render(conn, "index.json", comments: comments)
  end

  def create(conn, comment_params) do
    user = Guardian.Plug.current_resource(conn)
    changeset =
      Comment.changeset(%Comment{}, comment_params) |> Ecto.Changeset.put_assoc(:user, user)

    case Repo.insert(changeset) do
      {:ok, comment} ->
        conn
        |> put_status(:created)
        |> render("show.json", comment: Repo.preload(comment, [:user]))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Lift.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    comment =
      Comment
      |> where([c], c.id == ^id)
      |> preload([:user])
      |> Comment.with_likes
      |> Repo.one!

    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Repo.get!(Comment, id)
    changeset = Comment.changeset(comment, comment_params)

    case Repo.update(changeset) do
      {:ok, comment} ->
        render(conn, "show.json", comment: comment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Lift.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Repo.get!(Comment, id)
    changeset = Comment.changeset(comment, %{deleted: true})

    case Repo.update(changeset) do
      {:ok, _comment} ->
        send_resp(conn, :no_content, "")
      {:error, changeset} ->
        conn
        |> put_status(:internal_server_error)
        |> render(Lift.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
