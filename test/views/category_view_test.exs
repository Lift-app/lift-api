defmodule Lift.CategoryViewTest do
  use Lift.ConnCase, async: true

  import Lift.Factory

  alias Lift.CategoryView

  test "index.json" do
    category = insert(:category)

    rendered_categories = CategoryView.render("index.json", categories: [category])

    assert rendered_categories == %{
      data: [CategoryView.render("category.json", category: category)]
    }
  end

  test "show.json" do
    category = insert(:category)

    rendered_category = CategoryView.render("show.json", category: category)

    assert rendered_category == %{
      data: CategoryView.render("category.json", category: category)
    }
  end

  test "category.json" do
    category = insert(:category)

    rendered_category = CategoryView.render("category.json", category: category)

    assert rendered_category == %{
      id: category.id,
      name: category.name,
      description: category.description
    }
  end
end
