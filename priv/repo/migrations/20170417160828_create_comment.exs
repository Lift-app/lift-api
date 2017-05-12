defmodule Lift.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def up do
    create table(:comments) do
      add :user_id,   references(:users)
      add :post_id,   references(:posts)
      add :parent_id, references(:comments)
      add :type,      :type, default: "text"
      add :body,      :text
      add :deleted,   :boolean, default: false, null: false
      add :anonymous, :boolean, default: false, null: false

      timestamps()
    end
  end

  def down do
    drop table(:comments)
  end
end
