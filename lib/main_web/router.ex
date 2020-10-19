defmodule MainWeb.Router do
  use MainWeb, :router

  def absinthe_before_send(conn, _x) do
    conn
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

    plug Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
      pass: ["*/*"],
      json_decoder: Jason

    # plug Guardian.Plug.Pipeline, module: Main.Guardian, otp_app: :main
    # plug Guardian.Plug.VerifyHeader
    # plug Guardian.Plug.LoadResource, allow_blank: false
    # plug Absinthe.Plug, schema: MainWeb.Schema
    plug Main.Guardian.Pipeline
    plug MainWeb.Context
  end

  scope "/", MainWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/api", PlaygroundController, :index
  end

  scope "/api" do
    pipe_through [:api]

    post "/",
         Absinthe.Plug,
         schema: MainWeb.Schema,
         before_send: {__MODULE__, :absinthe_before_send}
  end

  # post "/api",
  #      Absinthe.Plug,
  #      schema: MainWeb.Schema,
  #      interface: :simple

  # forward "/api",
  #         Absinthe.Plug,
  #         schema: MainWeb.Schema,
  #         interface: :simple

  # forward "/graphiql",
  #         Absinthe.Plug.GraphiQL,
  #         schema: MainWeb.Schema,
  #         interface: :simple

  # Other scopes may use custom stacks.
  # scope "/api", MainWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MainWeb.Telemetry
    end
  end
end
