defmodule Lift.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def up do
    create table(:posts) do
      add :user_id,     references(:users)
      add :category_id, references(:categories)
      add :body,        :text, null: false
      add :locked,      :boolean, default: false, null: false

      timestamps()
    end
  end

  def down do
    drop table(:posts)
  end
end
