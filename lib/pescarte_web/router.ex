defmodule PescarteWeb.Router do
  use PescarteWeb, :router

  import PhxLiveStorybook.Router
  import PescarteWeb.UserAuthentication
  # import PescarteWeb.UserAuthorization

  alias PescarteWeb.UserAuthentication
  # alias PescarteWeb.UserAuthorization

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
    plug PescarteWeb.GraphQL.Context
  end

  ## Endpoints para versão browser

  scope "/api" do
    pipe_through [:api]

    forward "/", Absinthe.Plug, schema: PescarteWeb.GraphQL.Schema
  end

  scope("/", do: storybook_assets())

  scope "/", PescarteWeb do
    pipe_through [:browser]

    get "/", LandingPageController, :show
    live_storybook("/storybook", backend_module: PescarteWeb.Storybook)
  end

  scope "/", PescarteWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{UserAuthentication, :redirect_if_user_is_authenticated}] do
      live "/acessar", UserLoginLive, :new
      live "/usuarios/recuperar_senha", UserForgotPasswordLive, :new
      live "/usuarios/recuperar_senha/:token", UserResetPasswordLive, :edit
    end

    post "/acessar", LoginController, :create
  end

  scope "/", PescarteWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{UserAuthentication, :mount_current_user}] do
      live "/usuarios/confirmar", UserConfirmationInstructionsLive, :new
      live "/usuarios/confirmar/:token", UserConfirmationLive, :edit
    end
  end

  scope "/app", PescarteWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{UserAuthentication, :ensure_authenticated}] do
      live "/perfil", UserProfileLive
      live "/pesquisadores", PesquisadoresLive, :index

      scope "/relatorios" do
        # FIXME mudar para live view
        # get "/", RelatorioController, :index
        live "/mensal", RelatorioMensalLive
      end
    end

    delete "/desconectar", LoginController, :delete
  end

  # scope "/app/admin", PescarteWeb do
  #   pipe_through [:browser, :require_authenticated_user, :require_admin_role]

  #   live_session :require_admin_role,
  #     on_mount: [
  #       {UserAuthentication, :ensure_authenticated},
  #       {UserAuthorization, :ensure_admin_role}
  #     ] do
  #   end
  # end

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

    scope "/dev" do
      pipe_through :api

      forward "/graphiql", Absinthe.Plug.GraphiQL, schema: PescarteWeb.GraphQL.Schema
    end
  end
end
