defmodule Lift.Router do
  use Lift.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Lift do
    pipe_through :api

    resources "/posts", PostController, except: [:new, :edit]

    get "/posts/:post_id/comments", CommentController, :index
    resources "/comments", CommentController, except: [:new, :edit, :index]

    get "/categories/:category_ids/posts", CategoryController, :posts
    resources "/categories", CategoryController, except: [:new, :edit]

    put "/comments/:comment_id/like", LikeController, :like_comment
    put "/posts/:post_id/like", LikeController, :like_post
  end
end
