defmodule PescarteWeb.Router do
  use PescarteWeb, :router

  import Supabase.GoTrue.Plug
  alias Supabase.GoTrue

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PescarteWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :graphql do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug PescarteWeb.GraphQL.Context
  end

  scope "/api" do
    pipe_through :graphql

    forward "/", Absinthe.Plug, schema: PescarteWeb.GraphQL.Schema
  end

  scope "/", PescarteWeb do
    pipe_through :browser

    get "/", LandingController, :show
    get "/equipes", EquipesController, :show
    get "/cooperativas", CooperativasController, :show
    get "/sobre", AboutUsController, :show
    get "/publicacoes", JournalController, :show
    get "/censo", CensoController, :show
    get "/confirmar", TokenController, :confirm

    delete "/acessar", LoginController, :delete

    get "/agenda", AgendaController, :show

    scope "/noticias" do
      get "/noti1", Noti1Controller, :show
      get "/noti2", Noti2Controller, :show
      get "/noti3", Noti3Controller, :show
    end

    scope "/publicacoes" do
      get "/boletin", BoletinController, :show
    end

    scope "/contato" do
      get "/", ContactController, :show
      post "/", ContactController, :send_email
    end
  end

  scope "/", PescarteWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live "/acessar", LoginLive, :show
    post "/acessar", LoginController, :create
  end

  scope "/app/pesquisa", PescarteWeb.Pesquisa do
    pipe_through :browser

    live_session :require_authenticated_user,
      on_mount: [
        PescarteWeb.NavbarLive,
        {PescarteWeb.SessionContext, :mount_session_from_conn},
        {GoTrue.LiveView, :ensure_authenticated},
        {PescarteWeb.Flash, :flash}
      ] do
      live "/perfil", PesquisadorLive.Show, :show

      scope "/pesquisadores" do
        live "/", PesquisadorLive.Index, :index
        live "/cadastro", PesquisadorLive.Index, :new
        live "/:id", PesquisadorLive.Show, :show
      end

      scope "/relatorios" do
        live "/", RelatorioLive.Index, :index
        live "/:id/editar/:tipo", RelatorioLive.Index, :edit
        get "/:id/download-pdf", RelatorioController, :download_pdf
        post "/compilar-relatorios", RelatorioController, :compilar_relatorios
        live "/novo/:tipo", RelatorioLive.Index, :new
      end
    end
  end
end
