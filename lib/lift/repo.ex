defmodule Lift.Repo do
  use Ecto.Repo, otp_app: :lift
  use Scrivener, page_size: 20
end
