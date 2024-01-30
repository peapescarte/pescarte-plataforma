defmodule PescarteWeb.Router do
  use PescarteWeb, :router

  import PhoenixStorybook.Router
  import PescarteWeb.Authentication

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {PescarteWeb.Layouts, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(:fetch_current_user)
  end

  pipeline :graphql do
    plug(PescarteWeb.GraphQL.Context)
  end

  scope "/api" do
    pipe_through(:graphql)

    forward("/", Absinthe.Plug, schema: PescarteWeb.GraphQL.Schema)
  end

  scope "/" do
    storybook_assets()
  end

  scope "/", PescarteWeb do
    pipe_through(:browser)

    get("/", LandingController, :show)

    live_storybook("/storybook", backend_module: PescarteWeb.Storybook)
  end

  scope "/", PescarteWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    get("/acessar", LoginController, :show)
    post("/acessar", LoginController, :create)
  end

  scope "/app/pesquisa", PescarteWeb.Pesquisa do
    pipe_through(:browser)
    # pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{PescarteWeb.Authentication, :ensure_authenticated}] do
      live("/perfil", ProfileLive)
      live("/pesquisadores", ListPesquisadorLive)
      live("/cadastro", CadastroPesquisadorLive)

      scope "/relatorios" do
        live("/", RelatorioLive.Index, :index)
        live("/new", RelatorioLive.Index, :new)
        live("/:id/edit", RelatorioLive.Index, :edit)
        get("/:id/download-pdf", RelatorioController, :download_pdf)
        post("/compilar-relatorios", RelatorioController, :compilar_relatorios)
      end
    end
  end
end
