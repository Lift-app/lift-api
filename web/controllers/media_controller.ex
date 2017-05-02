defmodule Lift.MediaController do
  use Lift.Web, :controller

  alias Lift.Post
  alias Lift.Audio

  def post(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)
    audio_path = Audio.url({"#{id}.ogg", post})

    conn
    |> put_resp_content_type("audio/ogg")
    |> Plug.Conn.send_file(200, audio_path)
  end
end
