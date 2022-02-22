defmodule FuschiaWeb.CidadeController do
  @moduledoc false

  use FuschiaWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Fuschia.Database
  alias Fuschia.Entities.Cidade
  alias FuschiaWeb.Swagger.{CidadeSchemas, Response, Security}

  action_fallback FuschiaWeb.FallbackController

  tags(["cidades"])
  security(Security.private())

  operation(:create,
    request_body:
      {"Atributos de criação", "application/json", CidadeSchemas.CreateRequest, required: true},
    responses:
      [created: {"Resposta de sucesso", "application/json", CidadeSchemas.Cidade}] ++
        Response.errors(:unauthorized)
  )

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"cidade" => cidade_attr}) do
    with {:ok, cidade} <- Database.create(Cidade, cidade_attr) do
      render_response(cidade, conn, :created)
    end
  end
end
