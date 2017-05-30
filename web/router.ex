defmodule Lift.Router do
  use Lift.Web, :router

  pipeline :api do
    plug :accepts, ["json"]

    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/", Lift do
    pipe_through :api

    resources "/tokens", TokenController, only: [:create, :delete]

    scope "/users" do
      put "/:id/follow", FollowController, :follow
      put "/:id/unfollow", FollowController, :unfollow

      scope "/me" do
        get "/", UserController, :me
        put "/", UserController, :update
        put "/onboarded", UserController, :onboarded
        put "/interests", UserController, :update_interests
      end

      get "/:username", UserController, :show
    end

    scope "/categories" do
      get "/:name", CategoryController, :show
      resources "/", CategoryController, except: [:new, :edit, :show]

      get "/:category_ids/posts", CategoryController, :posts
    end

    scope "/posts" do
      resources "/", PostController, except: [:new, :edit]

      get "/voorjou", PostController, :voorjou

      get "/search/:query", PostController, :search

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
      get "/avatars/:id", MediaController, :avatar
    end

    scope "/oauth" do
      get "/:provider", OAuthController, :index
      get "/:provider/callback", OAuthController, :callback
    end

    scope "/invite" do
      get "/make", UserController, :make_invite
    end
  end
end
