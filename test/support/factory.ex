defmodule Lift.Factory do
  use ExMachina.Ecto, repo: Lift.Repo

  def user_factory do
    %Lift.User{
      username: sequence("rimko"),
      email: sequence("rimko@gmail.com"),
      password_hash: "foo"
    }
  end

  def category_factory do
    %Lift.Category{
      name: "Werk",
      description: "Alles over werken"
    }
  end

  def post_factory do
    %Lift.Post{
      user: build(:user),
      category: build(:category),
      body: "Test post"
    }
  end

  def comment_factory do
    %Lift.Comment{
      user: build(:user),
      post: build(:post),
      body: "Just a comment!"
    }
  end
end
