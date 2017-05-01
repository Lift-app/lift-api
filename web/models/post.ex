defmodule Lift.Post do
  use Lift.Web, :model

  import EctoEnum

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

  @required_fields ~w(user_id category_id body type)a

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
    |> Ecto.changeset.cast(params, @required_fields)
    |> constraints
    |> validate_required(@required_fields)
  end

  defp constraints(struct) do
    struct
    |> unique_constraint(:name)
  end
end
