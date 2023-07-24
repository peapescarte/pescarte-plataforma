defmodule PlataformaDigital.RelatorioListController do
  use PlataformaDigital, :controller

  def show(conn, _params) do
    user = conn.assigns.current_user
    render(conn, :show, user: user, edit?: false)

  end
 end
