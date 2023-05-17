defmodule PescarteWeb.Router do
  use PescarteWeb, :router

  import PhoenixStorybook.Router
  import PescarteWeb.Authentication

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PescarteWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end
  #plug :match
  plug PescarteWeb.ErrorHTML, layout: false

  pipeline :api do
    plug :accepts, ["json"]
    plug PescarteWeb.LocalePlug
    plug PescarteWeb.GraphQL.Context
  end

  ## Endpoints para versão browser

  scope "/" do
    storybook_assets()
  end

  scope "/", PescarteWeb do
    pipe_through :browser

    get "/", LandingController, :show

    live_storybook("/storybook", backend_module: PescarteWeb.Storybook)

  end
  #match _ do
  #  send_resp(conn, 404, "not found")
  #end

  scope "/", PescarteWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/acessar", LoginController, :show
    post "/acessar", LoginController, :create
  end

  scope "/app", PescarteWeb.App do
    pipe_through :browser
    # pipe_through [:browser, :require_authenticated_user]

    get "/perfil", ResearcherController, :show_profile
  end

  ## Endpoints para API pública

  scope "/api" do
    pipe_through :api

    forward "/", Absinthe.Plug, schema: PescarteWeb.GraphQL.Schema
  end

  ## Endpoints para ambiente de desenvolvimento

  if Mix.env() == :dev do
    # scope "/dev" do
    #   pipe_through :browser

    #   forward "/mailbox", Plug.Swoosh.MailboxPreview
    # end

    scope "/dev" do
      pipe_through :api

      forward "/graphiql", Absinthe.Plug.GraphiQL, schema: PescarteWeb.GraphQL.Schema
    end
  end
end
