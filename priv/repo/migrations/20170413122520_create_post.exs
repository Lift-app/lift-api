defmodule Lift.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def up do
    TypeEnum.create_type

    create table(:posts) do
      add :user_id,     references(:users)
      add :category_id, references(:categories)
      add :body,        :text
      add :type,        :type, default: "text"
      add :locked,      :boolean, default: false, null: false
      add :anonymous,   :boolean, default: false, null: false

      timestamps()
    end

    create index(:posts, [:user_id])
  end

  def down do
    drop table(:posts)
    TypeEnum.drop_type
  end
end
