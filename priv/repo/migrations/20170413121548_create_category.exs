defmodule Lift.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def up do
    create table(:categories) do
      add :name,        :string
      add :description, :string

      timestamps()
    end
  end

  def down do
    drop table(:categories)
  end
end
