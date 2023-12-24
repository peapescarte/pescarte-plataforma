defmodule PlataformaDigital.ImageBank do
  use PlataformaDigital, :live_view

  def mount(socket) do
    list = [
    ]

    {:ok, assign(socket, relatorios: list)}
  end
end
