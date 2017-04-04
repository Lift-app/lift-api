defmodule Lift.Router do
  use Lift.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Lift do
    pipe_through :api
  end
end
