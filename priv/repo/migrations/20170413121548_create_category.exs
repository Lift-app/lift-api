defmodule Lift.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def up do
    create table(:categories) do
      add :name,        :string, null: false
      add :description, :string, null: true
    end

    create unique_index(:categories, ["lower(name)"])
  end

  def down do
    drop table(:categories)
  end
end
