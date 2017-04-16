defmodule Lift.Category do
  use Lift.Web, :model

  schema "categories" do
    field :name,        :string
    field :description, :string
  end

  @required_fields ~w(name)a
  @optional_fields ~w(description)a

  defp constraints(struct) do
    struct
    |> unique_constraint(:name, name: :categories_lower_name_index)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> constraints
    |> validate_required(@required_fields)
  end
end
