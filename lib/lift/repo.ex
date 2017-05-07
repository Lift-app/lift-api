defmodule Lift.Repo do
  use Ecto.Repo, otp_app: :lift
  use Scrivener, page_size: 10, max_page_size: 10
end
