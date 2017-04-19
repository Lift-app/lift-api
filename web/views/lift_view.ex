defmodule Lift.LikeView do
  use Lift.Web, :view

  def render("like.json", conn) do
    %{data: conn.data}
  end
end
