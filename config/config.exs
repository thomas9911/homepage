# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :main, MainWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "kasA/Ua8oj0Z28MNwIGFQor9BR9J8cTYxbmCEXJjURMLKGB5qCFf+FGkQpjFPRWV",
  render_errors: [view: MainWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Main.PubSub,
  live_view: [signing_salt: "r1C4Qdjr"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :tesla, :adapter, Tesla.Adapter.Mint

config :main, Main.CouchDB,
  # url: "https://httpbin.org/anything",
  url: "http://192.168.99.100:5984",
  user: "user",
  password: "password"

config :main, Main.CouchDB.Setup,
  admin_user: "admin",
  admin_password: "password"

config :main, Main.Guardian,
  issuer: "guardian",
  secret_key: "CNgADZHEyWro3WZCaBISlIpUJF6c/1GpNL18aM+iiMbKhXLv2Z8CyixEcgcr3+oG"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
