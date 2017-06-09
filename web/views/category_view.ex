defmodule Lift.CategoryView do
  use Lift.Web, :view

  def render("index.json", %{categories: categories}) do
    %{data: render_many(categories, Lift.CategoryView, "category.json")}
  end

  def render("show.json", %{category: category}) do
    %{data: render_one(category, Lift.CategoryView, "category.json")}
  end

  def render("category.json", %{category: category}) do
    %{
      id: category.id,
      name: category.name,
      description: category.description,
      post_count: length(category.posts),
      is_interested: category.is_interested
    }
  end
end
