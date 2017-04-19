defmodule Lift.Repo.Migrations.CreateLike do
  use Ecto.Migration

  def up do
    create table(:likes) do
      add :user_id,    references(:users)
      add :post_id,    references(:posts)
      add :comment_id, references(:comments)
      add :type,       :string

      timestamps()
    end
  end

  def down do
    drop table(:likes)
  end
end
