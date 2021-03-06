defmodule Lift.Factory do
  use ExMachina.Ecto, repo: Lift.Repo

  def user_factory do
    %Lift.User{
      username: sequence(:username, &"johndoe#{&1}"),
      email: sequence(:email, &"Johndoe#{&1}@gmail.com"),
      password_hash: "foo",
      categories: []
    }
  end

  def category_factory do
    %Lift.Category{
      name: sequence(:name, &"Werk#{&1}"),
      description: "Alles over werken",
      post_count: 0
    }
  end

  def post_factory do
    %Lift.Post{
      user: %Lift.User{},
      category: build(:category),
      body: "Test post",
      type: :text,
      comments: [],
      likes: []
    }
  end

  def comment_factory do
    %Lift.Comment{
      user: build(:user),
      post: build(:post),
      body: "Just a comment!",
      type: :text
    }
  end

  def like_factory do
    %Lift.Like{
      user: build(:user)
    }
  end

  def follow_factory do
    %Lift.Follow{
      user_following: build(:user),
      user_follower: build(:user)
    }
  end
end
