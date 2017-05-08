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

    scope "/users/me" do
      get "/", UserController, :show
      put "/interests", UserController, :update_interests
    end

    scope "/categories" do
      resources "/", CategoryController, except: [:new, :edit]

      get "/:category_ids/posts", CategoryController, :posts
    end

    scope "/posts" do
      resources "/", PostController, except: [:new, :edit]

      resources "/:post_id/comments", CommentController, only: [:index, :create]

      put "/:id/like", LikeController, :like
      put "/:id/unlike", LikeController, :unlike
    end

    scope "/comments" do
      resources "/", CommentController, only: [:delete, :update, :show]

      put "/:id/like", LikeController, :like
      put "/:id/unlike", LikeController, :unlike
    end

    scope "/media" do
      get "/posts/:id", MediaController, :post
      get "/comments/:id", MediaController, :comment
      get "/avatar/:id", MediaController, :avatar
    end
  end
end
