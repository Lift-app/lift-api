# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :lift,
  ecto_repos: [Lift.Repo]

# Configures the endpoint
config :lift, Lift.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "uwsLndilowUVZkUaeXHC+Km3nqA5wBetUU3CL6vJqbR+T/FY3o9jnbq47dJ3QMY4",
  render_errors: [view: Lift.ErrorView, accepts: ~w(json)],
  pubsub: [name: Lift.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Guardian
config :guardian, Guardian,
  allowed_algos: ["HS512"],
  issuer: "Lift",
  ttl: { 30, :days },
  allowed_drift: 2000,
  secret_key: System.get_env("GUARDIAN_SECRET_KEY") || "super secret",
  serializer: Lift.GuardianSerializer
