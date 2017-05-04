defmodule Lift.PostTest do
  use Lift.ModelCase

  alias Lift.Post

  @valid_attrs %{user_id: 1, category_id: 1, body: "some content", locked: true, type: :text}
  @invalid_attrs %{type: :not_a_type}

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end
end
