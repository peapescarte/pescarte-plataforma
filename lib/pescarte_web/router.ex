defmodule PescarteWeb.Router do
  use PescarteWeb, :router

  import PescarteWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PescarteWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug PescarteWeb.LocalePlug
    plug PescarteWeb.RequireApiKeyPlug
  end

  ## Endpoints para versão browser

  scope "/", PescarteWeb do
    pipe_through [:browser]

    get "/", LandingPageController, :show
  end

  scope "/", PescarteWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/cadastrar", UserRegistrationController, :new
    post "/cadastrar", UserRegistrationController, :create

    get "/acessar", LoginController, :new
    post "/acessar", LoginController, :create

    get "/recuperar_senha", UserResetPasswordController, :new
    post "/recuperar_senha", UserResetPasswordController, :create
    get "/recuperar_senha/:token", UserResetPasswordController, :edit
    put "/recuperar_senha/:token", UserResetPasswordController, :update

    ## Será que posso criar um ResearchRegistrationController ou seria um UserRegistrationController com
    ## :bursary = pesquisador ?????

    ## testando, pois após as mudança de nome não está rodando o que fiz:
    #  get "/perfil", UserProfileController, :edit
    #  put "/perfil", UserProfileController, :update
    #  get "/perfil/listar", UserProfileController, :show
  end

  scope "/app", PescarteWeb do
    pipe_through [:browser, :require_authenticated_user]

    scope "/relatorios" do
      get "/mensal/criar", RelatorioMensalController, :new
      post "/mensal/criar", RelatorioMensalController, :create
      get "/mensal/listar", RelatorioMensalController, :show
    end

    get "/perfil", UserProfileController, :edit
    put "/perfil", UserProfileController, :update
    get "/perfil/listar", UserProfileController, :show

    scope "/admin" do
      get "/", AdminController, :index
      get "/pesq/listar", PesquisadorController, :show
      get "/pesq", PesquisadorController, :index
      get "/pesq/novo", PesquisadorController, :new
    end

    get "/perfil/confirmar_email/:token",
        UserProfileController,
        :confirm_email
  end

  scope "/app", PescarteWeb do
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

      live_dashboard "/dashboard", metrics: PescarteWeb.Telemetry
    end
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
