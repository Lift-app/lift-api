defmodule Lift.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def up do
    create table(:posts) do
      add :body,      :text
      add :is_locked, :boolean, default: false, null: false

      timestamps()
    end
  end

  def down do
    drop table(:posts)
  end
end
