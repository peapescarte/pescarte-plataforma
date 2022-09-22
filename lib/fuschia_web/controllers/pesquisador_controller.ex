defmodule FuschiaWeb.PesquisadorController do
  use FuschiaWeb, :controller

  def index(conn, _params) do
    list_research = Fuschia.ResearchModulus.list_researcher()
    render(conn, "index.html", research: list_research)
  end

  def show(conn, _params) do
    user = conn.assigns.current_user
    render(conn, "show.html", user: user)
  end
end
