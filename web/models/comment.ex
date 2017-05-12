defmodule Lift.Comment do
  use Lift.Web, :model

  alias Lift.Post

  schema "comments" do
    belongs_to :user,    Lift.User
    belongs_to :post,    Lift.Post
    belongs_to :comment, Lift.Comment, foreign_key: :parent_id
    has_many   :likes,   Lift.Like

    field :body,       :string
    field :type,       TypeEnum
    field :deleted,    :boolean, default: false
    field :anonymous,  :boolean, default: false
    field :like_count, :integer, default: 0, virtual: true

    timestamps()
  end

  @required_fields ~w(post_id type)a
  @optional_fields ~w(body parent_id)a

  def with_associations(query) do
    preload(query, [:user, :comment])
  end

  def with_likes(query) do
    from c in query,
      left_join: l in assoc(c, :likes),
      select: %{c | like_count: count(l.id)},
      group_by: c.id
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> Post.validate_body_present
    |> validate_required(@required_fields)
  end
end
