defmodule FuschiaWeb.Router do
  use FuschiaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug FuschiaWeb.LocalePlug
    plug FuschiaWeb.RequireApiKeyPlug
    plug ProperCase.Plug.SnakeCaseParams
  end

  pipeline :auth do
    plug FuschiaWeb.Auth.Pipeline
  end

  pipeline :api_swagger do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: FuschiaWeb.Swagger.ApiSpec
  end

  scope "/" do
    pipe_through :browser

    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end

  scope "/api" do
    pipe_through :api_swagger

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/api", FuschiaWeb do
    pipe_through :api

    post "/login", AuthController, :login
    post "/signup", AuthController, :signup
  end

  scope "/api", FuschiaWeb do
    pipe_through [:auth, :api]

    resources "/campi", CampusController, only: [:create, :index, :delete]
    resources "/cidades", CidadeController, only: [:create]
  end
end
