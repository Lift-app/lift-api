defmodule Lift.Factory do
  use ExMachina.Ecto, repo: Lift.Repo

  def user_factory do
    %Lift.User{
      username: sequence(:username, &"johndoe#{&1}"),
      email: sequence(:email, &"Johndoe#{&1}@gmail.com"),
      password_hash: "foo",
      categories: build_list(3, :category)
    }
  end

  def category_factory do
    %Lift.Category{
      name: sequence(:name, &"Werk#{&1}"),
      description: "Alles over werken"
    }
  end

  def post_factory do
    %Lift.Post{
      user: build(:user),
      category: build(:category),
      body: "Test post",
      type: :text
    }
  end

  def comment_factory do
    %Lift.Comment{
      user: build(:user),
      post: build(:post),
      body: "Just a comment!"
    }
  end

  def like_factory do
    %Lift.Like{
      user: build(:user)
    }
  end
end
