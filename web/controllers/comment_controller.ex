defmodule Lift.CommentController do
  use Lift.Web, :controller

  alias Lift.{Comment, Post}

  def index(conn, %{"post_id" => post_id}) do
    post = Repo.get!(Post, post_id)
    comments = Repo.all(from c in assoc(post, :comments), preload: [:user, :comment])

    render(conn, "index.json", comments: comments)
  end

  def create(conn, post_params) do
    changeset = Comment.changeset(%Comment{}, post_params)

    case Repo.insert(changeset) do
      {:ok, comment} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", comment_path(conn, :show, comment))
        |> render("show.json", comment: Repo.preload(comment, [:user]))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Lift.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Repo.get!(Comment, id) |> Repo.preload([:user])
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
