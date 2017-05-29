defmodule Lift.ProfileInfo do
  use Lift.Web, :model

  schema "profile_info" do
    belongs_to :user, Lift.User

    field :field,  ProfileFieldEnum
    field :value,  :string
    field :public, :boolean, default: false
  end

  @required_fields ~w(field value)a
  @optional_fields ~w(public)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validations
    |> constraints
    |> validate_required(@required_fields)
  end

  defp constraints(struct) do
    struct
    |> unique_constraint(:field, name: :profile_info_user_id_field_index)
  end

  defp validations(struct) do
    struct
    |> validate_length(:value, max: 600)
  end
end
