defmodule Main.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MainWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Main.PubSub},
      # Start the Endpoint (http/https)
      MainWeb.Endpoint
      # Start a worker by calling: Main.Worker.start_link(arg)
      # {Main.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Main.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MainWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
