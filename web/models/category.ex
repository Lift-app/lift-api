defmodule Lift.Category do
  use Lift.Web, :model

  schema "categories" do
    has_many :posts, Lift.Post

    field :name,        :string
    field :description, :string
    field :post_count,  :integer, virtual: true, default: 0
  end

  @required_fields ~w(name)a
  @optional_fields ~w(description)a

  def with_post_count(query) do
    from c in query,
      left_join: p in assoc(c, :posts),
      select: %{c | post_count: count(p.id)},
      group_by: c.id
  end

  defp constraints(struct) do
    struct
    |> unique_constraint(:name, name: :categories_lower_name_index)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> constraints
    |> validate_required(@required_fields)
  end
end
