defmodule Lift.Router do
  use Lift.Web, :router

  pipeline :api do
    plug :accepts, ["json"]

    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", Lift do
    pipe_through :api

    get "/voorjou", PostController, :voorjou

    resources "/tokens", TokenController, only: [:create, :delete]

    scope "/user" do
      resources "/", UserController, only: [:show], singleton: true
    end

    scope "/categories" do
      resources "/", CategoryController, except: [:new, :edit]

      get "/:category_ids/posts", CategoryController, :posts
    end

    scope "/posts" do
      resources "/", PostController, except: [:new, :edit]

      get "/:id/comments", CommentController, :index

      put "/:id/like", LikeController, :like
      put "/:id/unlike", LikeController, :unlike
    end

    scope "/comments" do
      resources "/", CommentController, except: [:new, :edit, :index]

      put "/:id/like", LikeController, :like
      put "/:id/unlike", LikeController, :unlike
    end
  end
end
