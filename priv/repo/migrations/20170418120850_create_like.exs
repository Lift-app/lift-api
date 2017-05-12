defmodule Lift.Repo.Migrations.CreateLike do
  use Ecto.Migration

  def up do
    create table(:likes) do
      add :user_id,    references(:users)
      add :post_id,    references(:posts)
      add :comment_id, references(:comments)

      timestamps()
    end

    create index(:likes, [:user_id])
    create index(:likes, [:post_id])
    create index(:likes, [:comment_id])

    create unique_index(:likes, [:user_id, :post_id])
    create unique_index(:likes, [:user_id, :comment_id])
  end

  def down do
    drop table(:likes)
  end
end
