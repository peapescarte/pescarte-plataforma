defmodule PescarteWeb.Router do
  use PescarteWeb, :router

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
