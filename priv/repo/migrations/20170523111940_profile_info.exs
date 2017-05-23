defmodule Lift.Repo.Migrations.ProfileInfo do
  use Ecto.Migration

  def up do
    ProfileFieldEnum.create_type

    create table(:profile_info) do
      add :user_id, references(:users)
      add :field,   :profile_field
      add :value,   :text
      add :public,  :boolean, default: false
    end

    create unique_index(:profile_info, [:user_id, :field])
  end

  def down do
    drop table(:profile_info)
    ProfileFieldEnum.drop_type
  end
end
