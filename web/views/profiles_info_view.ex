defmodule Lift.ProfileInfoView do
  use Lift.Web, :view

  def render("info.json", %{profile_info: profile_info}) do
    render_profile_info(profile_info, %{})
  end

  defp render_profile_info([], acc) do
    acc
  end
  defp render_profile_info([info | rest], acc) do
    value = if info.public, do: info.value, else: nil
    acc = Map.put(acc, info.field, value)

    render_profile_info(rest, acc)
  end
end
