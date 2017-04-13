defmodule Lift.Post do
  use Lift.Web, :model

  schema "posts" do
    belongs_to :user,     Lift.User
    belongs_to :category, Lift.Categories

    field :body,      :string
    field :is_locked, :boolean, default: false

    timestamps()
  end

  @params ~w(body is_locked)

  defp constraints(struct) do
    struct
    |> unique_constraint(:name)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [@params])
    |> validate_required([@params])
  end
end
