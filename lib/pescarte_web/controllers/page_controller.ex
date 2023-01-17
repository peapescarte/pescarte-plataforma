defmodule PescarteWeb.PageController do
  use PescarteWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
