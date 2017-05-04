defmodule Lift.Post do
  use Lift.Web, :model
  use Arc.Ecto.Schema

  schema "posts" do
    belongs_to :user,     Lift.User
    belongs_to :category, Lift.Category
    has_many   :comments, Lift.Comment
    has_many   :likes,    Lift.Like

    field :body,       :string
    field :type,       TypeEnum
    field :locked,     :boolean, default: false
    field :anonymous,  :boolean, default: false
    field :like_count, :integer, default: 0, virtual: true

    timestamps()
  end

  @required_fields ~w(user_id category_id type)a
  @optional_fields ~w(body)a

  def ordered(query) do
    order_by(query, desc: :inserted_at)
  end

  def with_associations(query) do
    preload(query, [:user, :category])
  end

  def with_likes(query) do
    from p in query,
      left_join: l in assoc(p, :likes),
      select: %{p | like_count: count(l.id)},
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

  defp constraints(struct) do
    struct
    |> unique_constraint(:name)
  end

  defp validate_body_present(struct) do
    type = get_field(struct, :type)

    if type == :text and (get_field(struct, :body) in [nil, ""]) do
      add_error(struct, :body, "missing body")
    else
      struct
    end
  end
end
