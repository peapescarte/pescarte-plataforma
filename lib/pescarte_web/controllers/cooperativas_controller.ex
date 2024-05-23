defmodule PescarteWeb.CooperativasController do
  use PescarteWeb, :controller

  def show(conn, _params) do
    render(conn, :show, error_message: nil)
  end
end
