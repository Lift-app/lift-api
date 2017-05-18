defmodule Lift.FollowController do
  use Lift.Web, :controller
  use Guardian.Phoenix.Controller

  alias Lift.Follow

  plug Guardian.Plug.EnsureAuthenticated, handler: Lift.TokenController

  def follow(conn, %{"id" => following_id}, user, _claims) do
    changeset =
      Follow.changeset(%Follow{}, %{following_id: following_id, follower_id: user.id})

    case Repo.insert(changeset) do
      {:ok, _follow} ->
        send_resp(conn, :no_content, "")
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Lift.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def unfollow(conn, %{"id" => following_id}, user, _claims) do
    query = from f in Follow,
      where: f.follower_id == ^user.id and f.following_id == ^following_id
    follow = Repo.one!(query)

    Repo.delete!(follow)

    send_resp(conn, :no_content, "")
  end
end
