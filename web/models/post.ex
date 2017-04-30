defmodule Lift.Post do
  use Lift.Web, :model

  schema "posts" do
    belongs_to :user,     Lift.User
    belongs_to :category, Lift.Category
    has_many   :comments, Lift.Comment
    has_many   :likes,    Lift.Like

    field :body,      :string
    field :locked,    :boolean, default: false
    field :anonymous, :boolean, default: false

    timestamps()
  end

  @required_fields ~w(user_id category_id body)a

  def ordered(query) do
    order_by(query, desc: :inserted_at)
  end

  def with_associations(query) do
    preload(query, [:user, :category])
  end

  def with_likes(query) do
    # select count(likes.id) as likes, posts.*
    #   from posts
    #   left join likes on (likes.post_id = posts.id) where posts.id=1
    #   group by posts.id
    from p in query,
      left_join: l in assoc(p, :likes),
      select: %{p | likes: count(l.id)},
      group_by: p.id
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> constraints
    |> validate_required(@required_fields)
  end

  defp constraints(struct) do
    struct
    |> unique_constraint(:name)
  end
end
