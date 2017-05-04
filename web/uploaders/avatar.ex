defmodule Lift.Avatar do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions   ~w(original thumb)a
  @extensions ~w(.jpg .jpeg .gif .png)

  def __storage, do: Arc.Storage.Local

  # Whitelist file extensions:
  def validate({file, _}) do
    @extensions |> Enum.member?(Path.extname(file.file_name))
  end

  # Define a thumbnail transformation:
  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 250x250^ -gravity center -extent 250x250 -format png", :png}
  end

  def filename(version, _) do
    version
  end

  # Override the storage directory:
  def storage_dir(_version, {_file, scope}) do
    Application.get_env(:arc, :storage_dir) <> "avatars/#{scope.id}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(_version, _scope) do
    "https://placehold.it/100x100"
  end
end
