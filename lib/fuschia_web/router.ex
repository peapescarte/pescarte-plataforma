defmodule FuschiaWeb.Router do
  use FuschiaWeb, :router

  import FuschiaWeb.UserAuth

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

  ## Endpoints para versão browser

  scope "/", FuschiaWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/cadastrar", UserRegistrationController, :new
    post "/cadastrar", UserRegistrationController, :create

    get "/acessar", UserSessionController, :new
    post "/acessar", UserSessionController, :create

    get "/recuperar_senha", UserResetPasswordController, :new
    post "/recuperar_senha", UserResetPasswordController, :create
    get "/recuperar_senha/:token", UserResetPasswordController, :edit
    put "/recuperar_senha/:token", UserResetPasswordController, :update
  end

  scope "/app", FuschiaWeb do
    pipe_through [:browser, :require_authenticated_user]

    scope "/relatorios" do
      get "/mensal/criar", MonthlyReportController, :new
      post "/mensal/criar", MonthlyReportController, :create
    end

    get "/perfil", UserProfileController, :edit
    put "/perfil", UserProfileController, :update

    get "/perfil/confirmar_email/:token",
        UserProfileController,
        :confirm_email
  end

  scope "/app", FuschiaWeb do
    pipe_through [:browser]

    delete "/desconectar", UserSessionController, :delete

    get "/confirmar", UserConfirmationController, :new
    post "/confirmar", UserConfirmationController, :create
    get "/confirmar/:token", UserConfirmationController, :edit
    put "/confirmar/:token", UserConfirmationController, :update
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
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
