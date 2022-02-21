defmodule FuschiaWeb.CampusController do
  @moduledoc false

  use FuschiaWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Fuschia.Db
  alias Fuschia.Entities.Campus
  alias Fuschia.Queries.Campi
  alias FuschiaWeb.Swagger.{CampusSchemas, Response, Security}
  alias OpenApiSpex.Schema

  action_fallback FuschiaWeb.FallbackController

  tags(["campi"])
  security(Security.private())

  operation(:create,
    request_body:
      {"Atributos de criação", "application/json", CampusSchemas.CreateRequest, required: true},
    responses:
      [created: {"Resposta de sucesso", "application/json", CampusSchemas.Campus}] ++
        Response.errors(:unauthorized)
  )

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"campus" => campus_attr}) do
    with {:ok, campus} <- Db.create(Campus, campus_attr) do
      render_response(campus, conn, :created)
    end
  end

  operation(:index,
    responses:
      [ok: {"Resposta de sucesso", "application/json", CampusSchemas.AllCampiResponse}] ++
        Response.errors(:unauthorized)
  )

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, _params) do
    Campi.query()
    |> Db.list()
    |> render_response(conn)
  end

  operation(:delete,
    parameters: [
      id: [
        in: :path,
        type: %Schema{type: :string, minimum: 1},
        description: "ID do Campus",
        example: "1111111",
        required: true
      ]
    ],
    responses:
      [ok: {"Resposta de sucesso", "application/json", CampusSchemas.Campus}] ++
        Response.errors(:unauthorized)
  )

  @spec delete(Plug.Conn.t(), map) :: Plug.Conn.t()
  def delete(conn, %{"campus_id" => campus_id}) do
    with %Campus{} = campus <- Db.get(Campi.query(), campus_id),
         {:ok, _campus} <- Db.delete(campus) do
      render_response(campus, conn)
    end
  end
end
