use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :main, MainWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :main, Main.CouchDB.Setup,
  admin_user: "admin",
  admin_password: "password"
