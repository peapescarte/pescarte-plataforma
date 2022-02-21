defmodule FuschiaWeb.Router do
  use FuschiaWeb, :router

  import FuschiaWeb.UserAuth

  import Surface.Catalogue.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {FuschiaWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
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

  ## Authentication routes

  scope "/", FuschiaWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/cadastrar", UserRegistrationController, :new
    post "/cadastrar", UserRegistrationController, :create
    get "/acessar", UserSessionController, :new
    post "/acessar", UserSessionController, :create
    get "/resetar_senha", UserResetPasswordController, :new
    post "/resetar_senha", UserResetPasswordController, :create
    get "/resetar_senha/:token", UserResetPasswordController, :edit
    put "/resetar_senha/:token", UserResetPasswordController, :update
  end

  scope "/apps", FuschiaWeb do
    pipe_through [:browser, :require_authenticated_user]

    scope "/usuarios" do
      get "/:user_id/configuracoes", UserSettingsController, :edit
      put "/:user_id/configuracoes", UserSettingsController, :update

      get "/:user_id/configuracoes/confirmar_email/:token",
          UserSettingsController,
          :confirm_email
    end
  end

  scope "/app", FuschiaWeb do
    pipe_through [:browser]

    delete "/desconectar", UserSessionController, :delete

    scope "/usuarios" do
      get "/confirmar", UserConfirmationController, :new
      post "/confirmar", UserConfirmationController, :create
      get "/confirmar/:token", UserConfirmationController, :edit
      post "/confirmar/:token", UserConfirmationController, :update
    end
  end
end
