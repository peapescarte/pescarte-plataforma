defmodule PescarteWeb.EquipesController do
  use PescarteWeb, :controller

  def show(conn, _params) do
    current_path = conn.request_path
    linhas_pesquisas = get_data_from_file("linhas_pesquisas.json")
    membros = get_data_from_file("membros.json")

    render(conn, :show,
      linhas_pesquisas: linhas_pesquisas,
      membros: membros,
      error_message: nil,
      current_path: current_path
    )
  end

  defp get_data_from_file(file_name) do
    "equipes"
    |> Pescarte.get_static_file_path(file_name)
    |> File.read!()
    |> Jason.decode!()
  end
end
