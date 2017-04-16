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

alias Lift.{Repo, User, Category, Post}

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

# Posts
[
  "Hoe oud zou je zijn als je niet wist hoe oud je bent?",
  "Wat is slechter, falen of nooit proberen?",
  "Als het leven te kort is waarom doe je dan zoveel dingen die je niet leuk vindt en doen je weinig dingen die je leuk vindt?",
  "Wanneer het allemaal gezegd en gedaan is, zal je dan meer zeggen dan dat je gedaan hebt?",
  "Wat zal je het liefst willen veranderen in deze wereld?",
  "Doe je waar je in gelooft?",
  "Indien de gemiddelde levensduur 40 jaar was, hoe anders zou je dan leven?",
  "Ben je meer bezorgd over dingen juist doen of de juiste dingen doen?",
  "Als je een pasgeboren kind één advies mocht meegeven, wat zou dit dan zijn?",
  "Zou je de wet overtreden om een geliefde te redden?",
  "Kan  jij iets noemen wat je anders doet dan de meeste mensen?"
] |> Enum.each(fn question ->
  Repo.insert!(%Post{
    user_id: 1,
    category_id: Enum.random(1..4),
    body: question,
    is_locked: Enum.random([true, false])
  })
end)
