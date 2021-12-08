defmodule FuschiaWeb.Swagger.ApiSpec do
  @moduledoc false

  alias OpenApiSpex.{Components, Info, OpenApi, Paths, SecurityScheme, Server}
  alias FuschiaWeb.{Endpoint, Router}

  @behaviour OpenApi

  @impl OpenApi
  def spec do
    OpenApiSpex.resolve_schema_modules(%OpenApi{
      components: %Components{
        securitySchemes: %{
          "api_key_header" => %SecurityScheme{
            type: "apiKey",
            in: "header",
            name: "X-API-KEY"
          },
          "api_key_query" => %SecurityScheme{
            type: "apiKey",
            in: "query",
            name: "api_key"
          },
          "authorization" => %SecurityScheme{
            type: "http",
            scheme: "bearer"
          }
        }
      },
      servers: [
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: "Fuschia API",
        version: "0.0.1"
      },
      paths: Paths.from_router(Router)
    })
  end
end
