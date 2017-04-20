defmodule Lift.Like do
  use Lift.Web, :model

  schema "likes" do
    belongs_to :user, Lift.User
    belongs_to :post, Lift.Post
    belongs_to :comment, Lift.Comment

    timestamps()
  end

  @required_fields ~w(user_id)a
  @optional_fields ~w(comment_id post_id)a

  defp constraints(struct) do
    struct
    |> unique_constraint(:user_id, name: :likes_user_id_post_id_index)
    |> unique_constraint(:user_id, name: :likes_user_id_comment_id_index)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:post_id)
    |> foreign_key_constraint(:comment_id)
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
