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

  pipeline :api_auth do
    plug FuschiaWeb.Auth.Pipeline
  end

  pipeline :api_swagger do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: FuschiaWeb.Swagger.ApiSpec
  end

  ## Endpoints para versão browser

  scope "/", FuschiaWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live "/cadastrar", UserRegistrationLive.New, :new, as: :user_registration
    get "/acessar", UserSessionController, :new
    post "/acessar", UserSessionController, :create
    live "/recuperar_senha", UserResetPasswordLive.New, :new, as: :user_reset_password
    live "/recuperar_senha/:token", UserResetPasswordLive.Edit, :edit, as: :user_reset_password
  end

  scope "/app", FuschiaWeb do
    pipe_through [:browser, :require_authenticated_user]

    scope "/usuarios" do
      live "/configuracoes", UserSettingsLive.Edit, :edit, as: :user_settings

      get "/configuracoes/confirmar_email/:token",
          UserSettingsController,
          :confirm_email
    end
  end

  scope "/app", FuschiaWeb do
    pipe_through [:browser]

    delete "/desconectar", UserSessionController, :delete

    scope "/usuarios" do
      live "/confirmar", UserConfirmationLive.New, :new, as: :user_confirmation
      live "/confirmar/:token", UserConfirmationLive.Edit, :edit, as: :user_confirmation
    end
  end

  scope "/" do
    pipe_through :browser

    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"

    live "/example", FuschiaWeb.ExampleLive
  end

  ## Endpoints para API pública

  scope "/api/v1" do
    pipe_through :api_swagger

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/api/v1", FuschiaWeb do
    pipe_through :api

    post "/acessar", AuthController, :login
    post "/cadastrar", AuthController, :signup
  end

  scope "/api/v1", FuschiaWeb do
    pipe_through [:api_auth, :api]

    resources "/campi", CampusController, only: [:create, :index, :delete]
    resources "/cidades", CidadeController, only: [:create]
    resources "/nucleos", NucleoController
  end

  ## Endpoints para ambiente de desenvolvimento

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
