defmodule Lift.UploadAuthPlug do
  alias Lift.OTA

  def init(opts) do
    Enum.into(opts, %{})
  end

  def call(%{params: params} = conn, opts) do
    token = Map.get(params, "token")
    handler = Map.get(opts, :handler)

    case OTA.verify_media_token(token) do
      :ok ->
        conn
      {:error, reason} ->
        params = Map.merge(params, %{reason: reason})
        apply(handler, :unauthenticated, [conn, params])
    end
  end
end
