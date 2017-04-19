defmodule Lift.Like do
  use Lift.Web, :model

  import Ecto.Query

  schema "likes" do
    belongs_to :user, Lift.User
    belongs_to :post, Lift.Post
    belongs_to :comment, Lift.Comment

    field :preexists, :boolean, virtual: true
    field :type,      :string

    timestamps()
  end

  @required_fields ~w(user_id type)a
  @optional_fields ~w(comment_id post_id)a

  defp preexists(struct) do
    case struct do
      %Ecto.Changeset{valid?: true, changes: changes} ->
        query =
          case changes[:type] do
            "comment" ->
                 from l in "likes",
               where: l.user_id    == ^changes[:user_id]
                  and l.comment_id == ^changes[:comment_id],
              select: l.id
            "post" ->
                 from l in "likes",
               where: l.user_id == ^changes[:user_id]
                  and l.post_id == ^changes[:post_id],
              select: l.id
        end
        case Lift.Repo.one(query) do
          nil ->
            put_change(struct, :preexists, false)
           id ->
            struct
            |> put_change(:preexists, true)
            |> put_change(:id, id)
        end
      _ ->
        struct
    end
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> preexists()
  end
end
