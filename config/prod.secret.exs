use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or you later on).
config :lift, Lift.Endpoint,
  secret_key_base: "J7CXsL5rPEnikOXI7RBt5XZrO42vVb+tfBujJ7SGwTbre3kxUdxX1vz/RVf0/zVX"

# Configure your database
config :lift, Lift.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "lift_prod",
  pool_size: 20
