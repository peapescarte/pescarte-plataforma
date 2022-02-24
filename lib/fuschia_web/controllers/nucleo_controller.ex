defmodule FuschiaWeb.NucleoController do
  @moduledoc false
  use FuschiaWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Fuschia.Db
  alias Fuschia.Entities.Nucleo
  alias Fuschia.Queries.Nucleos
  alias FuschiaWeb.Swagger.{NucleoSchemas, Response, Security}
  alias OpenApiSpex.Schema

  action_fallback FuschiaWeb.FallbackController

  tags(["nucleos"])
  security(Security.private())

  operation(:create,
    request_body:
      {"Atributos de criação", "application/json", NucleoSchemas.CreateRequest, required: true},
    responses:
      [created: {"Resposta de sucesso", "application/json", NucleoSchemas.Nucleo}] ++
        Response.errors(:unauthorized)
  )

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"nucleo" => nucleo_attr}) do
    with {:ok, nucleo} <- Db.create(Nucleo, nucleo_attr) do
      render_response(nucleo, conn, :created)
    end
  end

  operation(:index,
    responses:
      [ok: {"Resposta de sucesso", "application/json", NucleoSchemas.AllNucleoResponse}] ++
        Response.errors(:unauthorized)
  )

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, _params) do
    Nucleos.query()
    |> Db.list()
    |> render_response(conn)
  end

  operation(:show,
    parameters: [
      id: [
        in: :path,
        type: %Schema{type: :string, minimum: 1},
        description: "ID do Nucleo",
        example: "1111111",
        required: true
      ]
    ],
    responses:
      [ok: {"Resposta de sucesso", "application/json", NucleoSchemas.Nucleo}] ++
        Response.errors(:unauthorized)
  )

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => nucleo_id}) do
    with %Nucleo{} = nucleo <- Db.get(Nucleos.query(), nucleo_id) do
      render_response(nucleo, conn)
    end
  end

  operation(:update,
    request_body:
      {"Atributos de criação", "application/json", NucleoSchemas.CreateRequest, required: true},
    parameters: [
      id: [
        in: :path,
        type: %Schema{type: :string, minimum: 1},
        description: "ID do Nucleo",
        example: "1111111",
        required: true
      ]
    ],
    responses:
      [created: {"Resposta de sucesso", "application/json", NucleoSchemas.Nucleo}] ++
        Response.errors(:unauthorized)
  )

  @spec update(Plug.Conn.t(), map) :: Plug.Conn.t()
  def update(conn, %{"nucleo" => attrs, "id" => nucleo_id}) do
    with %Nucleo{} = nucleo <- Db.get(Nucleos.query(), nucleo_id),
         {:ok, updated_nucleo} <- Db.update_struct(nucleo, attrs) do
      render_response(updated_nucleo, conn)
    end
  end

  operation(:delete,
    parameters: [
      id: [
        in: :path,
        type: %Schema{type: :string, minimum: 1},
        description: "ID do Nucleo",
        example: "1111111",
        required: true
      ]
    ],
    responses:
      [ok: {"Resposta de sucesso", "application/json", NucleoSchemas.Nucleo}] ++
        Response.errors(:unauthorized)
  )

  @spec delete(Plug.Conn.t(), map) :: Plug.Conn.t()
  def delete(conn, %{"id" => nucleo_id}) do
    with %Nucleo{} = nucleo <- Db.get(Nucleos.query(), nucleo_id),
         {:ok, _nucleo} <- Db.delete(nucleo) do
      render_response(nucleo, conn)
    end
  end
end
