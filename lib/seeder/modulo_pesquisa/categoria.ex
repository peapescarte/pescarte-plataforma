defmodule Seeder.ModuloPesquisa.Categoria do
  alias Pescarte.ModuloPesquisa.Models.Midia.Categoria
  @behaviour Seeder.Entry

  @impl true
  def entries do
    [
      %Categoria{nome: "autoral"},
      %Categoria{nome: "local"},
      %Categoria{nome: "conteudo"},
      %Categoria{nome: "eventos"}
    ]
  end
end
