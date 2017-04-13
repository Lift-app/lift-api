defmodule Lift.ChangesetView do
  use Lift.Web, :view

  def render("error.json", %{changeset: changeset}) do
    errors = Enum.map(changeset.errors, &render_detail/1)

    %{errors: errors}
  end

  defp render_detail({field, {message, _}}) do
    "#{field} #{message}"
  end
  defp render_detail(message) do
    message
  end
end
