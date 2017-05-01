defmodule Lift.LikeController do
  use Lift.Web, :controller
  use Guardian.Phoenix.Controller

  alias Lift.Like

  plug Guardian.Plug.EnsureAuthenticated, handler: Lift.TokenController

  def like(%{path_info: [type | _]} = conn, %{"id" => id}, user, _claims) do
    changeset =
      case type do
        "posts" ->
          Like.changeset(%Like{}, %{user_id: user.id, post_id: id})
        "comments" ->
          Like.changeset(%Like{}, %{user_id: user.id, comment_id: id})
      end

    case Repo.insert(changeset) do
      {:ok, _like} ->
        send_resp(conn, :no_content, "")
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Lift.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def unlike(%{path_info: [type | _]} = conn, %{"id" => id}, user, _claims) do
    like =
      case type do
        "posts" ->
          Repo.one!(from l in Like, where: l.post_id == ^id and l.user_id == ^user.id)
        "comments" ->
          Repo.one!(from l in Like, where: l.comment_id == ^id and l.user_id == ^user.id)
      end

    Repo.delete!(like)
    send_resp(conn, :no_content, "")
  end
end
