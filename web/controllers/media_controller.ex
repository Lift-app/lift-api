defmodule Lift.MediaController do
  use Lift.Web, :controller

  alias Lift.{Audio, Avatar, Post, Comment, User}

  plug Lift.UploadAuthPlug, handler: Lift.TokenController

  def post(conn, %{"id" => id}) do
    post = from(p in Post, where: p.id == ^id and p.type == "audio") |> Repo.one!
    audio_path = Audio.url({"#{id}.ogg", post})

    conn
    |> put_resp_content_type("audio/ogg")
    |> Plug.Conn.send_file(200, audio_path)
  end

  def comment(conn, %{"id" => id}) do
    comment = from(c in Comment, where: c.id == ^id and c.type == "audio") |> Repo.one!
    audio_path = Audio.url({"#{id}.ogg", comment})

    conn
    |> put_resp_content_type("audio/ogg")
    |> Plug.Conn.send_file(200, audio_path)
  end

  def avatar(conn, %{"id" => id}) do
    user = from(u in User, where: u.id == ^id and not is_nil(u.avatar)) |> Repo.one!
    image_path = Avatar.url({"#{id}.png", user})

    conn
    |> put_resp_content_type("image/png")
    |> Plug.Conn.send_file(200, image_path)
  end
end
