defmodule PescarteWeb.LandingController do
  use PescarteWeb, :controller

  def show(conn, _params) do
    render(conn, :show)
  end
end
