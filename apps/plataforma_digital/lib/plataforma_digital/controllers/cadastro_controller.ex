defmodule PlataformaDigital.CadastroController do
  use PlataformaDigital, :controller

#  alias Identidades.Handlers.UsuarioHandler
#  alias PlataformaDigital.Authentication

  def show(conn, _params) do
    render(conn, :show, error_message: nil)
  end
end
