defmodule Lift.Category do
  use Lift.Web, :model

  schema "categories" do
    field :name,        :string
    field :description, :string

    timestamps()
  end

  @params ~w(name description)a

  defp constraints(struct) do
    struct
    |> unique_constraint(:name)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @params)
    |> constraints
    |> validate_required(@params)
  end
end
