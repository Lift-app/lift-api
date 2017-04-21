defmodule Lift.LikeController do
  use Lift.Web, :controller

  alias Lift.Like

  def like(%{path_info: [type | _]} = conn, %{"id" => id, "user_id" => user_id}) do
    changeset =
      case type do
        "posts" ->
          Like.changeset(%Like{}, %{user_id: user_id, post_id: id})
        "comments" ->
          Like.changeset(%Like{}, %{user_id: user_id, comment_id: id})
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

  def unlike(%{path_info: [type | _]} = conn, %{"id" => id, "user_id" => user_id}) do
    like =
      case type do
        "posts" ->
          Repo.one!(from l in Like, where: l.post_id == ^id and l.user_id == ^user_id)
        "comments" ->
          Repo.one!(from l in Like, where: l.comment_id == ^id and l.user_id == ^user_id)
      end

    Repo.delete!(like)
    send_resp(conn, :no_content, "")
  end
end
