defmodule Lift.Comment do
  use Lift.Web, :model

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
    field :liked,      :boolean, default: false, virtual: true

    timestamps()
  end

  @required_fields ~w(post_id type)a
  @optional_fields ~w(body parent_id anonymous)a

  def ordered(query) do
    order_by(query, desc: :inserted_at)
  end

  def with_associations(query) do
    preload(query, [:user, :comment])
  end

  def with_likes(query, user_id) do
    from c in query,
      left_join: l in assoc(c, :likes),
      left_join: ul in assoc(c, :likes), on: ul.user_id == ^user_id,
      select: %{c | like_count: count(l.id), liked: count(ul.id) != 0},
      group_by: c.id
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_length(:body, max: 600)
    |> validate_required(@required_fields)
  end

  def audio_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields ++ [:body])
  end
end
