defmodule PescarteWeb.PesquisadorController do
  use PescarteWeb, :controller

  def index(conn, _params) do
    list_research = Pescarte.ResearchModulus.list_researcher()
    render(conn, "index.html", research: list_research)
  end

  def show(conn, _params) do
    user = conn.assigns.current_user
    render(conn, "show.html", user: user)
  end

  def new(conn, _params) do
    ##  new_research = Pescarte.ResearchModulus.create_researcher(params)   research: new_research,
      render(conn, "new.html", error_message: nil)
  end

end
