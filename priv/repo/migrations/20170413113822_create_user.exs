defmodule Lift.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def up do
    create table(:users) do
      add :username,      :string
      add :email,         :string
      add :password_hash, :string
      add :banned,        :boolean, default: false
      add :avatar,        :string
      add :onboarded,     :boolean
      add :oauth,         :boolean, default: false
      add :facebook_id,   :string

      timestamps()
    end

    create unique_index(:users, ["lower(username)"])
    create unique_index(:users, ["lower(email)"])
  end

  def down do
    drop table(:users)
  end
end
