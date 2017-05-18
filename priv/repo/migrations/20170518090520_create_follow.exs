defmodule Lift.Repo.Migrations.CreateFollow do
  use Ecto.Migration

  def up do
    create table(:follows) do
      add :follower_id, references(:users)
      add :following_id, references(:users)
    end

    create unique_index(:follows, [:follower_id, :following_id])
  end

  def down do
    drop table(:follows)
  end
end
