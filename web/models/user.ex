defmodule Lift.User do
  use Lift.Web, :model

  schema "users" do
    field :username,      :string
    field :email,         :string
    field :password_hash, :string
    field :banned,        :boolean, default: false

    timestamps()
  end

  @required_fields ~w(username email password_hash banned)a

  defp constraints(struct) do
    struct
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  defp validations(struct) do
    struct
    |> validate_format(:email, ~r/.+@.+\..+/)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> constraints
    |> validations
    |> validate_required(@required_fields)
  end
end
