defmodule Lift.Facebook do
  @moduledoc """
  An OAuth2 strategy for Facebook.
  """
  use OAuth2.Strategy

  alias OAuth2.Strategy.AuthCode
  alias OAuth2.Client

  defp config do
    [strategy: Facebook,
     site: "https://graph.facebook.com",
     authorize_url: "https://www.facebook.com/dialog/oauth",
     token_url: "/oauth/access_token"]
  end

  def client do
    Application.get_env(:lift, Lift.Facebook)
    |> Keyword.merge(config())
    |> Client.new
  end

  def authorize_url!(params \\ []) do
    Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], _headers \\ []) do
    Client.get_token!(client(), params)
  end

  # Strategy Callbacks
  @doc false
  def authorize_url(client, params) do
    AuthCode.authorize_url(client, params)
  end

  @doc false
  def get_token(client, params, headers) do
    client
    |> put_param(:client_secret, client.client_secret)
    |> put_header("Accept", "application/json")
    |> AuthCode.get_token(params, headers)
  end
end
