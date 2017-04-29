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

alias Lift.{Repo, User, Category, Post, Comment, Like}

# Users
Repo.insert!(%User{
  username: "steve",
  email: "steve@gmail.com",
  password_hash: "foo"
})

# Categories
categories = ["Financiën", "Werk", "Gezondheid", "Dagelijks leven"]
Enum.each(categories, fn category ->
  Repo.insert!(%Category{name: category})
end)

# Posts
posts = [
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
]

Enum.each(posts, fn question ->
  Repo.insert!(%Post{
    user_id: 1,
    category_id: Enum.random(1..length(categories)),
    body: question,
    locked: Enum.random([true, false])
  })
end)

# Comments
comments = [
  "Nou, dat vind ik dus ook!", "Waarom dan?", "Zomaar.", "Dat snap ik niet",
  "Vind ik lastig.", "Je kan dit heel makkelijk doen", "Waarbij?"
]
Enum.each(comments, fn comment ->
  Repo.insert!(%Comment{
    user_id: 1,
    deleted: Enum.random([true, false, true, true]),
    post_id: Enum.random(1..length(posts)),
    body: comment
  })
end)

replies = [
  "Ik ook!", "Oke, doen we!", "Hoe laat?", "Aardbei", "Vind ik helemaal mooi",
  "Wie?", "Misschien wel, misschien niet", "Watskebeurt?"
]
Enum.each(replies, fn reply ->
  comment_id = Enum.random(1..length(comments))
  comment = Repo.get(Comment, comment_id)

  Repo.insert!(%Comment{
    user_id: 1,
    parent_id: comment.id,
    post_id: comment.post_id,
    body: reply
  })
end)

# Likes
Enum.each(1..length(posts), fn id ->
  post = Repo.get(Post, id)

  case Enum.random([true, false]) do
    true ->
      Repo.insert!(%Like{
        user_id: 1,
        post_id: post.id
      })
    false ->
      :ok
  end
end)

Enum.each(1..length(comments), fn id ->
  comment = Repo.get(Comment, id)

  case Enum.random([true, false]) do
    true ->
      Repo.insert!(%Like{
        user_id: 1,
        comment_id: comment.id
      })
    false ->
      :ok
  end
end)
