defmodule PescarteWeb.PGTRController do
  use PescarteWeb, :controller

  alias Pescarte.Municipios
  alias Pescarte.Municipios.Unit

  def show(conn, _params) do
    current_path = conn.request_path
    municipios = Municipios.list_municipio()
    units = Municipios.list_units()
    changeset = Municipios.change_unit(%Unit{})
    statuses = ["Concluído", "Pendente", "Em andamento"]

    render(conn, :show,
      municipios: municipios,
      units: units,
      statuses: statuses,
      changeset: changeset,
      current_path: current_path,
      error_message: nil
    )
  end

  # Para as manejo das municipios
  # Analisar melhor os render para casos de erro
  def create_municipio(conn, %{"municipio" => municipio_params}) do
    current_user_id = get_current_user_id(conn)
    municipio_params = municipio_params |> Map.put("created_by", current_user_id)

    case Municipios.create_municipio(municipio_params) do
      {:ok, _municipio} ->
        conn
        |> put_flash(:info, "Município criado com sucesso.")
        |> redirect(to: ~p"/pgtr")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :show, changeset: changeset)
    end
  end

  def update_municipio(conn, %{"id" => id, "municipio" => municipio_params}) do
    municipio = Municipios.get_municipio!(id)
    current_user_id = get_current_user_id(conn)
    municipio_params = municipio_params |> Map.put("updated_by", current_user_id)

    case Municipios.update_municipio(municipio, municipio_params) do
      {:ok, _municipio} ->
        conn
        |> put_flash(:info, "Município atualizado com sucesso.")
        |> redirect(to: ~p"/pgtr")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :show, municipio: municipio, changeset: changeset)
    end
  end

  # Para manejo das unidades
  def create_unit(conn, %{"unit" => unit_params}) do
    current_user_id = get_current_user_id(conn)
    unit_params = unit_params |> Map.put("created_by", current_user_id)

    case Municipios.create_unit(unit_params) do
      {:ok, _unit} ->
        conn
        |> put_flash(:info, "Unidade criada com sucesso.")
        |> redirect(to: ~p"/pgtr")

      {:error, %Ecto.Changeset{} = changeset} ->
        municipios = Municipios.list_municipio()
        render(conn, :show, changeset: changeset, municipios: municipios)
    end
  end

  def update_unit(conn, %{"unit" => unit_params}) do
    unit = Municipios.get_unit!(unit_params["id"])
    current_user_id = get_current_user_id(conn)
    unit_params = unit_params |> Map.put("updated_by", current_user_id)

    case Municipios.update_unit(unit, unit_params) do
      {:ok, _unit} ->
        conn
        |> put_flash(:info, "Unidade atualizada com sucesso.")
        |> redirect(to: ~p"/pgtr")

      {:error, %Ecto.Changeset{} = changeset} ->
        municipios = Municipios.list_municipio()
        render(conn, :show, municipios: municipios, changeset: changeset, error_message: nil)
    end
  end

  defp get_current_user_id(conn_or_socket) do
    user =
      case conn_or_socket do
        %Plug.Conn{} -> conn_or_socket.assigns[:current_user]
        %Phoenix.LiveView.Socket{} -> conn_or_socket.assigns[:current_user]
      end

    user && user.id
  end

  # Verificar a corretude

  # defp authenticate_user(conn, _opts) do
  #   user = conn.assigns[:current_user]

  #   if user && user.papel == :admin do
  #     conn
  #   else
  #     conn
  #     |> put_flash(:error, "Você não tem permissão para acessar essa página.")
  #     |> redirect(to: ~p"/")
  #     |> halt()
  #   end
  # end
end
