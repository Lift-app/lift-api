defmodule Lift.CommentController do
  use Lift.Web, :controller
  use Guardian.Phoenix.Controller

  alias Lift.{Comment, Post, Audio}

  plug Guardian.Plug.EnsureAuthenticated, handler: Lift.TokenController

  def index(conn, %{"post_id" => post_id}, user, _claims) do
    post = Repo.get!(Post, post_id)
    comments =
      assoc(post, :comments)
      |> Comment.with_associations
      |> Comment.with_likes(user.id)
      |> Repo.all

    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"type" => "audio"} = comment_params, user, _claims) do
    audio = Map.get(comment_params, "audio", "")
    changeset =
      Comment.changeset(%Comment{}, comment_params)
      |> Ecto.Changeset.put_assoc(:user, user)

    transaction = Repo.transaction(fn ->
      comment = Repo.insert!(changeset)

      case Audio.store({audio, comment}) do
        {:ok, _filename} -> comment
        {:error, _error} -> Repo.rollback(:bad_audio)
      end
    end)

    case transaction do
      {:ok, comment} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", comment_path(conn, :show, comment))
        |> render("show.json", comment: Repo.preload(comment, [:user]))
      {:error, :bad_audio} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{"errors": "Invalid audio file"})
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Lift.ChangesetView, "error.json", changeset: changeset)
    end
  end
  def create(conn, comment_params, user, _claims) do
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

  def show(conn, %{"id" => id}, user, _claims) do
    comment =
      Comment
      |> where([c], c.id == ^id)
      |> preload([:user])
      |> Comment.with_likes(user.id)
      |> Repo.one!

    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}, _user, _claims) do
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

  def delete(conn, %{"id" => id}, _user, _claims) do
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
