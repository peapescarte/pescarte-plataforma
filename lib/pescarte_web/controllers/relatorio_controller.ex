defmodule PescarteWeb.RelatorioController do
  use PescarteWeb, :controller

  def index(conn, _params) do
    text(conn, "AQUI VÃO TER OS RELATÓRIOS")
  end
end
