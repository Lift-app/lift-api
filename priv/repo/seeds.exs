# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Lift.Repo.insert!(%Lift.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Lift.{Repo, User, Category}

# Users
Repo.insert!(%User{
  username: "rimko",
  email: "rimko@gmail.com",
  password_hash: "foo"
})

# Categories
["Financiën", "Werk", "Gezondheid", "Dagelijks leven"] |> Enum.each(fn category ->
  Repo.insert!(%Category{name: category})
end)
