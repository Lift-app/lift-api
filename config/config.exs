# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :lift,
  ecto_repos: [Lift.Repo],
  timezone: "Europe/Amsterdam"

config :arc,
  storage: Arc.Storage.Local,
  storage_dir: System.get_env("STORAGE_DIR") || "#{Path.absname(".")}/web/uploads/"

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

# Guardian
config :guardian, Guardian,
  allowed_algos: ["HS512"],
  issuer: "Lift",
  ttl: {30, :days},
  allowed_drift: 2000,
  secret_key: System.get_env("GUARDIAN_SECRET_KEY") || "super secret",
  serializer: Lift.GuardianSerializer

config :redix,
  host: System.get_env("REDIS_HOST") || "localhost"

# OAuth2
config :oauth2,
  debug: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
