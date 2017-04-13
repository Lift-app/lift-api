defmodule Lift.Category do
  use Lift.Web, :model

  schema "categories" do
    field :name,        :string
    field :description, :string

    timestamps()
  end

  defp constraints(struct) do
    struct
    |> unique_constraint(:name)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description])
    |> constraints
    |> validate_required([:name, :description])
  end
end
