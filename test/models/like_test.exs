defmodule Lift.LikeTest do
  use Lift.ModelCase

  alias Lift.Like

  @valid_attrs %{user_id: 1, post_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Like.changeset(%Like{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Like.changeset(%Like{}, @invalid_attrs)
    refute changeset.valid?
  end
end
