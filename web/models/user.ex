defmodule Lift.User do
  use Lift.Web, :model
  use Arc.Ecto.Schema

  schema "users" do
    many_to_many :categories, Lift.Category,
      join_through: "user_interests",
      on_replace: :delete
    has_many :follows,      Lift.Follow, foreign_key: :following_id
    has_many :profile_info, Lift.ProfileInfo, on_replace: :delete

    field :username,      :string
    field :email,         :string
    field :password,      :string, virtual: true
    field :password_hash, :string
    field :banned,        :boolean, default: false
    field :avatar,        Lift.Avatar.Type
    field :onboarded,     :boolean, default: false
    field :oauth,         :boolean, default: false
    field :facebook_id,   :string
    field :following,     :boolean, virtual: true
    field :followers,     :integer, virtual: true, default: 0

    timestamps()
  end

  @required_fields ~w(username email)a
  @optional_fields ~w(password)a

  @required_oauth_fields ~w(username oauth)a
  @optional_oauth_fields ~w(email facebook_id)a

  def find_by_email(email \\ "") do
    from u in __MODULE__, where: ilike(u.email, ^email)
  end

  def with_following(query, user_id) do
    from u in query,
      left_join: f in Lift.Follow,
        on: f.following_id == u.id and f.follower_id == ^user_id,
      select: %{u | following: count(f.id) != 0},
      group_by: u.id
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> constraints
    |> validations
    |> validate_required(@required_fields)
    |> cast_attachments(params, [:avatar])
    |> hash_password
  end

  def oauth_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_oauth_fields ++ @optional_oauth_fields)
    |> unique_constraint(:email)
    |> unique_constraint(:facebook_id)
    |> validate_length(:username, min: 3)
    |> validate_required(@required_oauth_fields)
  end

  defp constraints(struct) do
    struct
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end

  defp validations(struct) do
    struct
    |> validate_format(:email, ~r/.+@.+\..+/)
    |> validate_length(:username, min: 3)
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
