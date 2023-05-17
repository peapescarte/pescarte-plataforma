defmodule PescarteWeb.App.ResearcherController do
  use PescarteWeb, :controller

  def show_profile(conn, _params) do
    # current_user = conn.assigns.current_user
    mock_user = %{
      avatar: nil,
      profile_banner: nil,
      first_name: "Zoey",
      last_name: "Pessanha",
      pesquisador: %{
        minibio: "Olá sou eu mesma!",
        link_lattes: "https://github.com/zoedsoupe",
        link_linkedin: "https://linkedin.com/in/zoedsoupe",
        bolsa: :pesquisa
      }
    }

    render(conn, :show_profile, user: mock_user)
  end
end
