defmodule Lift.FollowTest do
  use Lift.ModelCase

  alias Lift.Follow

  @valid_attrs %{following_id: 1, follower_id: 2}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Follow.changeset(%Follow{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Follow.changeset(%Follow{}, @invalid_attrs)
    refute changeset.valid?
  end
end
