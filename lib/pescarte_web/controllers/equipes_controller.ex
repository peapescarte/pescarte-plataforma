defmodule PescarteWeb.EquipesController do
  use PescarteWeb, :controller

  def show(conn, _params) do
    {:ok, data} =
      "priv/static/equipes.json"
      |> File.read!()
      |> Jason.decode()

    render(conn, :show, data: data, error_message: nil)
  end
end
