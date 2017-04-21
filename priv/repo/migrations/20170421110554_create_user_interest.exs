defmodule Lift.Repo.Migrations.CreateUserInterest do
  use Ecto.Migration

  def up do
    create table(:user_interests) do
      add :user_id, references(:users)
      add :category_id, references(:categories)
    end

    create unique_index(:user_interests, [:user_id, :category_id])
  end

  def down do
    drop table(:interests)
  end
end
