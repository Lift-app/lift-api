defmodule Lift.Comment do
  use Lift.Web, :model

  schema "comments" do
    belongs_to :user, Lift.User
    belongs_to :post, Lift.Post
    belongs_to :comment, Lift.Comment, foreign_key: :parent_id

    field :body,      :string
    field :deleted,   :boolean, default: false
    field :anonymous, :boolean, default: false

    timestamps()
  end

  @required_fields ~w(user_id post_id body)a
  @optional_fields ~w(parent_id)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
