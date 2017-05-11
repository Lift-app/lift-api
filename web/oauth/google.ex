defmodule Lift.Google do
  @moduledoc """
  An OAuth2 strategy for Google.
  """
  use   OAuth2.Strategy
  alias OAuth2.Strategy.AuthCode
  alias OAuth2.{Client, Response}

  defp config do
    [strategy: Lift.Google,
     site: "https://accounts.google.com",
     authorize_url: "/o/oauth2/auth",
     token_url: "/o/oauth2/token"]
  end


  @doc """
  Public API, builds a new OAuth2.Client struct using the provided options.
  """
  def client() do
    Application.get_env(:lift, Lift.Google)
    |> Keyword.merge(config())
    |> Client.new()
  end

  def authorize_url!(params \\ []) do
    Client.authorize_url!(client(), params)
  end

  def get_token!(params \\ [], headers \\ []) do
    Client.get_token!(client(), params, headers)
  end

  def validate_token!(%{token: %{access_token: access_token}}) do
    response = Client.get!(client(), "https://www.googleapis.com/oauth2/v3/tokeninfo?access_token=#{access_token}")
    case response do
      %Response{body: %{"aud" => aud}} ->
        aud === client().client_id
      :otherwise ->
        nil
    end
  end

  # Strategy callbacks
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
