defmodule Lift.CommentTest do
  use Lift.ModelCase

  alias Lift.Comment

  @valid_attrs %{user_id: 1, post_id: 1, body: "some content", type: :text}
  @invalid_attrs %{body: nil}

  test "changeset with valid attributes" do
    changeset = Comment.changeset(%Comment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Comment.changeset(%Comment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
