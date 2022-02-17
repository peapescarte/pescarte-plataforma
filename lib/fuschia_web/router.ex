defmodule FuschiaWeb.Router do
  use FuschiaWeb, :router

  import Surface.Catalogue.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FuschiaWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug FuschiaWeb.LocalePlug
    plug FuschiaWeb.RequireApiKeyPlug
    plug ProperCase.Plug.SnakeCaseParams
  end

  pipeline :api_swagger do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: FuschiaWeb.Swagger.ApiSpec
  end

  scope "/" do
    pipe_through :browser

    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"

    live "/example", FuschiaWeb.ExampleLive
  end

  scope "/api" do
    pipe_through :api_swagger

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: FuschiaWeb.Telemetry
    end
  end

  if Mix.env() == :dev do
    scope "/" do
      pipe_through :browser
      surface_catalogue("/catalogue")
    end

    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
