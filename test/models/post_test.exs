defmodule Lift.PostTest do
  use Lift.ModelCase

  alias Lift.Post

  @valid_attrs %{user_id: 1, category_id: 1, body: "some content", is_locked: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end
end
