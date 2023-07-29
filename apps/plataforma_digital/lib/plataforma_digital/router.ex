defmodule PlataformaDigital.Router do
  use PlataformaDigital, :router

  import PhoenixStorybook.Router
  import PlataformaDigital.Authentication

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PlataformaDigital.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  scope "/" do
    storybook_assets()
  end

  scope "/", PlataformaDigital do
    pipe_through :browser

    get "/", LandingController, :show

    live_storybook("/storybook", backend_module: PlataformaDigital.Storybook)
  end

  scope "/", PlataformaDigital do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/acessar", LoginController, :show
    post "/acessar", LoginController, :create
  end

  scope "/app/pesquisa", PlataformaDigital do
    pipe_through :browser
    # pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{PlataformaDigital.Authentication, :ensure_authenticated}] do
      live "/perfil", Researcher.ProfileLive

      scope "/relatorios" do
        live "/mensal", Researcher.Relatorio.MensalLive
        live "/listagem", Researcher.Relatorio.ListReportLive
      end
    end
  end
end
