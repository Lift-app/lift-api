defmodule Lift.LikeController do
  use Lift.Web, :controller

  alias Lift.{Like}

  defp ok(conn, data) do
    conn
    |> put_status(:ok)
    |> render(:like, data: data)
  end

  defp unproc(conn, changeset) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(Lift.ChangesetView, :error, changeset: changeset)
  end

  def like_comment(conn, params) do
    like(conn, %Like{} |> Like.changeset(Map.merge(params, %{"type" => "comment"})))
  end

  def like_post(conn, params) do
    like(conn, %Like{} |> Like.changeset(Map.merge(params, %{"type" => "post"})))
  end

  def like(conn, changeset) do
    like = changeset |> Ecto.Changeset.apply_changes
    case changeset do
      %Ecto.Changeset{valid?: false} ->
        unproc(conn, changeset)
      %Ecto.Changeset{changes: %{preexists: false}} ->
        case Repo.insert(like) do
          {:ok, _} ->
            ok(conn, %{success: true, preexisted: false})
          {:error, changeset} ->
            unproc(conn, changeset)
        end
      %Ecto.Changeset{changes: %{preexists: true}} ->
        case Repo.delete(like) do
          {:ok, _} ->
            ok(conn, %{success: true, preexisted: true})
          {:error, changeset} ->
            unproc(conn, changeset)
        end
    end
  end
end
