defmodule Lift.Router do
  use Lift.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Lift do
    pipe_through :api

    resources "/posts", PostController, except: [:new, :edit]

    resources "/categories", CategoryController, except: [:new, :edit]
    get "/categories/:category_ids/posts", CategoryController, :posts
  end
end
