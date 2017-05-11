defmodule Lift.Auth do
  alias Lift.{Repo, User}
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def verify(email, password) do
    user = User.find_by_email(email) |> Repo.one

    cond do
      user && checkpw(password, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :bad_password}
      :otherwise ->
        dummy_checkpw()
        {:error, :not_found}
    end
  end

  def generate_token(data) do
    {:ok, jwt, _claims} = Guardian.encode_and_sign(data)
    jwt
  end
end
