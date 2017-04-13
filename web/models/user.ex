defmodule Lift.User do
  use Lift.Web, :model

  schema "users" do
    field :username,      :string
    field :email,         :string
    field :password_hash, :string
    field :is_banned,     :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username])
    |> validate_required([:username])
  end
end
