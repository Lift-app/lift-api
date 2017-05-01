defmodule Lift.Audio do
  use Arc.Definition

  use Arc.Ecto.Definition

  @versions [:original]

  def __storage, do: Arc.Storage.Local

  def validate({file, _}) do
    ~w(.ogg) |> Enum.member?(Path.extname(file.file_name))
  end

  def filename(version, _) do
    version
  end

  def storage_dir(version, {file, scope}) do
    type = scope.__struct__ |> Module.split |> List.last |> String.downcase
    Applcation.get_env(:arc, :audio_storage_dir) <> "#{type}/#{scope.id}"
  end
end
