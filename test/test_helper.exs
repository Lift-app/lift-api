ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Lift.Repo, {:shared, self()})
{:ok, _} = Application.ensure_all_started(:ex_machina)
