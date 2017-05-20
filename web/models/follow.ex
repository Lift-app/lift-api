defmodule Lift.Follow do
  use Lift.Web, :model

  schema "follows" do
    belongs_to :user_follower, Lift.User, foreign_key: :follower_id
    belongs_to :user_following, Lift.User, foreign_key: :following_id
  end

  @required_fields ~w(follower_id following_id)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> constraints
    |> validate_not_following_self
    |> validate_required(@required_fields)
  end

  defp validate_not_following_self(struct) do
    if get_field(struct, :follower_id) == get_field(struct, :following_id) do
      add_error(struct, :follower_id, "can't follow yourself")
    else
      struct
    end
  end

  defp constraints(struct) do
    struct
    |> unique_constraint(:follower_id, name: :follows_follower_id_following_id_index)
  end
end
