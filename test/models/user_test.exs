defmodule Lift.UserTest do
  use Lift.ModelCase

  alias Lift.User

  @valid_attrs %{username: "some content", email: "foo@bar.com", password_hash: "bar"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
