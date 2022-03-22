defmodule FuschiaWeb.NucleoController do
  @moduledoc false
  use FuschiaWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias Fuschia.Database
  alias Fuschia.ModuloPesquisa
  alias Fuschia.ModuloPesquisa.Models.NucleoModel
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
    with {:ok, nucleo} <- ModuloPesquisa.create_nucleo(nucleo_attr) do
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
    render_response(ModuloPesquisa.list_nucleo(), conn)
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
    with %NucleoModel{} = nucleo <- ModuloPesquisa.get_nucleo(nucleo_id) do
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
    with %NucleoModel{} = nucleo <- ModuloPesquisa.get_nucleo(nucleo_id),
         {:ok, updated_nucleo} <- ModuloPesquisa.update_nucleo(nucleo, attrs) do
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
    with %NucleoModel{} = nucleo <- ModuloPesquisa.get_nucleo(nucleo_id),
         {:ok, _nucleo} <- Database.delete(nucleo) do
      render_response(nucleo, conn)
    end
  end
end
