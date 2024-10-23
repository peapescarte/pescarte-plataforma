defmodule PescarteWeb.Noti9Controller do
  use PescarteWeb, :controller

  def show(conn, _params) do
    current_path = conn.request_path
    render(conn, :show, current_path: current_path, error_message: nil)
  end
end
