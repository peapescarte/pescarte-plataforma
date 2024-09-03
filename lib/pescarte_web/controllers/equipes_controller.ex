defmodule PescarteWeb.EquipesController do
  use PescarteWeb, :controller

  def show(conn, _params) do
    current_path = conn.request_path
    linhas_pesquisas = get_data_from_file("linhas_pesquisas.json")
    membros = get_data_from_file("membros.json")

    nucleo_norte = [
      "Equipe de Campo - Campos dos Goytacazes",
      "Equipe de Campo - Quissamã",
      "Equipe de Campo - São João da Barra",
      "Equipe de Campo - São Francisco de Itabapoana"
    ]

    nucleo_sul = [
      "Equipe de Campo - Carapebus/Macaé",
      "Equipe de Campo - Rio das Ostras",
      "Equipe de Campo - Arraial do Cabo",
      "Equipe de Campo - Cabo Frio",
      "Equipe de Campo - Armação dos Búzios"
    ]

    render(conn, :show,
      linhas_pesquisas: linhas_pesquisas,
      membros: membros,
      nucleo_norte: nucleo_norte,
      nucleo_sul: nucleo_sul,
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
