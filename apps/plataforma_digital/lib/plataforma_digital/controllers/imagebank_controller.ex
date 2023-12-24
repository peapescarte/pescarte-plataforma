defmodule PlataformaDigital.ImagebankController do
  use PlataformaDigital, :controller

  def show(conn, _params) do
    render(conn, :show, error_message: nil)
  end
end
