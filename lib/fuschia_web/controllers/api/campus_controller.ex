defmodule FuschiaWeb.CampusController do
  @moduledoc false

  use FuschiaWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Fuschia.ModuloPesquisa
  alias Fuschia.ModuloPesquisa.Models.CampusModel
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
    with {:ok, campus} <- ModuloPesquisa.create_campus(campus_attr) do
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
    render_response(ModuloPesquisa.list_campus(), conn)
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
    with %CampusModel{} = campus <- ModuloPesquisa.get_campus(campus_id),
         {:ok, _campus} <- ModuloPesquisa.delete(campus) do
      render_response(campus, conn)
    end
  end
end
