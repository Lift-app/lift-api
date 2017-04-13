defmodule Lift.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def up do
    create table(:categories) do
      add :name,        :string
      add :description, :string, null: true

      timestamps()
    end

    create unique_index(:categories, [:name])
  end

  def down do
    drop table(:categories)
  end
end
