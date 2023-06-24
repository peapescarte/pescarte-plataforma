defmodule PlataformaDigital.LandingController do
  use PlataformaDigital, :controller

  def show(conn, _params) do
    render(conn, :show)
  end
end
