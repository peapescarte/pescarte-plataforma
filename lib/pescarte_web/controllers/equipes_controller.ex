defmodule PescarteWeb.EquipesController do
  use PescarteWeb, :controller

  def show(conn, _params) do
    current_path = conn.request_path

    {:ok, data} =
      "equipes.json"
      |> File.read!()
      |> Jason.decode()

    render(conn, :show, current_path: current_path, data: data, error_message: nil)
  end
end
