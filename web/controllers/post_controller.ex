defmodule Lift.PostController do
  use Lift.Web, :controller
  use Guardian.Phoenix.Controller

  alias Lift.{Post, Audio}

  require Logger

  plug Guardian.Plug.EnsureAuthenticated, handler: Lift.TokenController

  def voorjou(conn, params, user, _claims) do
    user = Repo.preload(user, :categories)
    posts =
      Post
      |> Post.ordered
      |> Post.with_associations
      |> Post.with_liked(user.id)
      |> Post.by_interests(user.categories)
      |> Repo.paginate(params)

    render(conn, "index.json", posts: posts)
  end

  def search(conn, %{"query" => query} = params, user, _claims) do
    posts =
      Post
      |> Post.ordered
      |> Post.search(query)
      |> Post.with_associations
      |> Post.with_liked(user.id)
      |> Repo.paginate(params)

    render(conn, "index.json", posts: posts)
  end

  def index(conn, params, user, _claims) do
    posts =
      Post
      |> Post.ordered
      |> Post.with_associations
      |> Post.with_liked(user.id)
      |> Repo.paginate(params)

    render(conn, "index.json", posts: posts)
  end

  def create(conn, %{"type" => "audio"} = post_params, user, _claims) do
    audio = Map.get(post_params, "audio", "")
    changeset =
      Post.audio_changeset(%Post{}, post_params) |> Ecto.Changeset.put_assoc(:user, user)

    transaction = Repo.transaction(fn ->
      post = Repo.insert!(changeset)

      case Audio.store({audio, post}) do
        {:ok, _filename} ->
          post
        {:error, error} ->
          Logger.error error
          Repo.rollback(:bad_audio)
      end
    end)

    case transaction do
      {:ok, post} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", post_path(conn, :show, post))
        |> render("show.json", post: Repo.preload(post, [:category, :user, :comments, :likes]))
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
  def create(conn, post_params, user, _claims) do
    changeset =
      Post.changeset(%Post{}, post_params) |> Ecto.Changeset.put_assoc(:user, user)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", post_path(conn, :show, post))
        |> render("show.json", post: Repo.preload(post, [:category, :user, :comments, :likes]))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Lift.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, user, _claims) do
    post =
      Post
      |> Post.with_associations
      |> Post.with_liked(user.id)
      |> Repo.get!(id)

    render(conn, "show.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}, _user, _claims) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        render(conn, "show.json", post: post)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Lift.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}, _user, _claims) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    send_resp(conn, :no_content, "")
  end
end
