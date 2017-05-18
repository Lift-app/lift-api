defmodule Lift.Follow do
  use Lift.Web, :model

  schema "follows" do
    belongs_to :user_follower, Lift.User, foreign_key: :follower_id
    belongs_to :user_following, Lift.User, foreign_key: :following_id
  end

  @required_fields ~w(follower_id following_id)a

  defp constraints(struct) do
    struct
    |> unique_constraint(:follower_id, name: :follows_follower_id_following_id_index)
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
