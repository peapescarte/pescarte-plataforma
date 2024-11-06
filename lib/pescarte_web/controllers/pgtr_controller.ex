defmodule PescarteWeb.PGTRController do
  use PescarteWeb, :controller

  alias Pescarte.Regions
  alias Pescarte.Regions.Unit

  def show(conn, _params) do
    current_path = conn.request_path
    regions = Regions.list_regions()
    units = Regions.list_units()
    current_user_id = get_current_user_id(conn) # Há alguma forma melhor?
    changeset = Regions.change_unit(%Unit{})

    render(conn, :show, regions: regions, units: units, changeset: changeset, current_user: current_user_id, current_path: current_path, error_message: nil)
  end

  # Para as manejo das regiões
  # Analisar melhor os render para casos de erro
  def create_region(conn, %{"region" => region_params}) do
    case Regions.create_region(region_params) do
      {:ok, _region} ->
        conn
        |> put_flash(:info, "Região criada com sucesso.")
        |> redirect(to: ~p"/pgtr")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :show, changeset: changeset)
    end
  end

  def update_region(conn, %{"id" => id, "region" => region_params}) do
    region = Regions.get_region!(id)

    case Regions.update_region(region, region_params) do
      {:ok, _region} ->
        conn
        |> put_flash(:info, "Região atualizada com sucesso.")
        |> redirect(to: ~p"/pgtr")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :show, region: region, changeset: changeset)
    end
  end

  def delete_region(conn, %{"id" => id}) do
    region = Regions.get_region!(id)
    {:ok, _} = Regions.delete_region(region)

    conn
    |> put_flash(:info, "Região deletada com sucesso.")
    |> redirect(to: ~p"/pgtr")
  end

  # Para manejo das unidades
  def create_unit(conn, %{"unit" => unit_params}) do
    case Regions.create_unit(unit_params) do
      {:ok, _unit} ->
        conn
        |> put_flash(:info, "Unidade criada com sucesso.")
        |> redirect(to: ~p"/pgtr")

      {:error, %Ecto.Changeset{} = changeset} ->
        regions = Regions.list_regions()
        render(conn, :show, changeset: changeset, regions: regions)
    end
  end

  def update_unit(conn, %{"unit" => unit_params}) do
    current_path = conn.request_path
    unit = Regions.get_unit!(unit_params["id"])

    unit_params = unit_params |> Map.put("updated_by", conn.current_user_id)

    case Regions.update_unit(unit, unit_params) do
      {:ok, _unit} ->
        conn
        |> put_flash(:info, "Unidade atualizada com sucesso.")
        |> redirect(to: ~p"/pgtr")

      {:error, %Ecto.Changeset{} = changeset} ->
        regions = Regions.list_regions()
        render(conn, :show, regions: regions, changeset: changeset, current_path: current_path, error_message: nil)
    end
  end

  def delete_unit(conn, %{"id" => id}) do
    unit = Regions.get_unit!(id)
    {:ok, _} = Regions.delete_unit(unit)

    conn
    |> put_flash(:info, "Unidade deletada com sucesso.")
    |> redirect(to: ~p"/pgtr")
  end

  defp get_current_user_id(_conn) do
    # Não sei como funciona a autenticação certinho, vou precisar estudar melhor :)
  end
end
