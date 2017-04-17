defmodule Lift.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def up do
    create table(:comments) do
      add :user_id,   references(:users)
      add :post_id,   references(:posts)
      add :parent_id, references(:comments)
      add :body,      :text

      timestamps()
    end
  end

  def down do
    drop table(:comments)
  end
end
