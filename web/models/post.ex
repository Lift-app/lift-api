defmodule Lift.Post do
  use Lift.Web, :model
  use Arc.Ecto.Schema

  schema "posts" do
    belongs_to :user,     Lift.User
    belongs_to :category, Lift.Category
    has_many   :comments, Lift.Comment
    has_many   :likes,    Lift.Like

    field :body,          :string
    field :type,          TypeEnum
    field :locked,        :boolean, default: false
    field :anonymous,     :boolean, default: false
    field :liked,         :boolean, default: false, virtual: true

    timestamps()
  end

  @required_fields ~w(category_id type)a
  @optional_fields ~w(body anonymous)a

  def ordered(query) do
    order_by(query, desc: :inserted_at)
  end

  def with_associations(query) do
    preload(query, [:user, :category, :comments, :likes])
  end

  def with_liked(query, user_id) do
    from p in query,
      left_join: ul in assoc(p, :likes), on: ul.user_id == ^user_id,
      select: %{p | liked: count(ul.id) != 0},
      group_by: p.id
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> constraints
    |> validate_body_present
    |> validate_required(@required_fields)
  end

  def validate_body_present(struct) do
    type = get_field(struct, :type)

    if type == :text and (get_field(struct, :body) in [nil, ""]) do
      add_error(struct, :body, "missing body")
    else
      struct
    end
  end

  defp constraints(struct) do
    struct
    |> unique_constraint(:name)
  end
end
