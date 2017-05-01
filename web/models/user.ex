defmodule Lift.User do
  use Lift.Web, :model
  use Arc.Ecto.Schema

  schema "users" do
    many_to_many :categories, Lift.Category,
      join_through: "user_interests",
      on_replace: :delete

    field :username,      :string
    field :email,         :string
    field :password,      :string, virtual: true
    field :password_hash, :string
    field :banned,        :boolean, default: false
    field :avatar,        Lift.Avatar.Type

    timestamps()
  end

  @required_fields ~w(username email password)a

  def find_by_email(email) do
    from u in __MODULE__, where: u.email == ^email
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> constraints
    |> validations
    |> cast_attachments(params, [:avatar])
    |> validate_required(@required_fields)
    |> hash_password
  end

  defp constraints(struct) do
    struct
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  defp validations(struct) do
    struct
    |> validate_format(:email, ~r/.+@.+\..+/)
    |> validate_length(:password, min: 5)
  end

  defp hash_password(struct) do
    if password = get_change(struct, :password) do
      put_change(struct, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
    else
      struct
    end
  end
end
