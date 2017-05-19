defmodule Lift.MediaController do
  use Lift.Web, :controller

  alias Lift.{Audio, Avatar, Post, Comment, User}

  plug Lift.UploadAuthPlug, handler: Lift.TokenController

  def post(conn, %{"id" => id}) do
    post = from(p in Post, where: p.id == ^id and p.type == "audio") |> Repo.one!
    audio_path = Audio.url({"#{id}.wav", post})

    conn
    |> put_resp_header("content-type", "audio/x-wav")
    |> Plug.Conn.send_file(200, audio_path)
  end

  def comment(conn, %{"id" => id}) do
    comment = from(c in Comment, where: c.id == ^id and c.type == "audio") |> Repo.one!
    audio_path = Audio.url({"#{id}.wav", comment})

    conn
    |> put_resp_header("content-type", "audio/x-wav")
    |> Plug.Conn.send_file(200, audio_path)
  end

  def avatar(conn, %{"id" => id} = params) do
    user = from(u in User, where: u.id == ^id and not is_nil(u.avatar)) |> Repo.one!
    version = if Map.has_key?(params, "thumb"), do: :thumb, else: :original
    image_path = Avatar.url({"#{id}.png", user}, version)

    conn
    |> put_resp_content_type("image/png")
    |> Plug.Conn.send_file(200, image_path)
  end
end
