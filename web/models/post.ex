defmodule Lift.Post do
  use Lift.Web, :model

  schema "posts" do
    belongs_to :user,     Lift.User
    belongs_to :category, Lift.Category
    has_many   :comments, Lift.Comment
    has_many   :likes,    Lift.Like

    field :body,      :string
    field :is_locked, :boolean, default: false

    timestamps()
  end

  @required_fields ~w(user_id category_id body is_locked)a

  defp constraints(struct) do
    struct
    |> unique_constraint(:name)
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
end
