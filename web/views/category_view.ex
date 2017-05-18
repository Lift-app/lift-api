defmodule Lift.CategoryView do
  use Lift.Web, :view

  def render("index.json", %{categories: categories}) do
    %{data: render_many(categories, Lift.CategoryView, "category.json")}
  end

  def render("show.json", %{category: category}) do
    %{data: render_one(category, Lift.CategoryView, "category.json")}
  end

  def render("category.json", %{category: category}) do
    Map.take(category, [:id, :name, :description, :post_count])
  end
end
