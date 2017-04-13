defmodule Lift.User do
  use Lift.Web, :model

  schema "users" do
    field :username,      :string
    field :email,         :string
    field :password_hash, :string
    field :is_banned,     :boolean, default: false

    timestamps()
  end

  @params ~w(username email password_hash is_banned)

  defp constraints(struct) do
    struct
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @params)
    |> constraints
    |> validate_required(@params)
  end
end
