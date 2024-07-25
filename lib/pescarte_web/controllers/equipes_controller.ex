defmodule PescarteWeb.EquipesController do
  use PescarteWeb, :controller

  def show(conn, _params) do
    current_path = conn.request_path

    {:ok, data} =
      "equipes"
      |> Pescarte.get_static_file_path("equipes.json")
      |> File.read!()
      |> Jason.decode()

    render(conn, :show, data: data, error_message: nil, current_path: current_path)
  end
end
