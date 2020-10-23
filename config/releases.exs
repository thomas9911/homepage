import Config

config :main, MainWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: "gpFS5ceKN59dPzbYxkQt6S3cxUNwe2bHg+RhnHa/45bSvZi57a7HGZ0vYkJ23M2y",
  server: true,
  code_reloader: false,
  live_reload: []
