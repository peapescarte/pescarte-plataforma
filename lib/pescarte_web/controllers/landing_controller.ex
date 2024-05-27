defmodule PescarteWeb.LandingController do
  use PescarteWeb, :controller

  def index(conn, _params) do
    render(conn, :index, error_message: nil)
  end

  def equipes(conn, _params) do
    render(conn, :equipes, error_message: nil)
  end
end
