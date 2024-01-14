defmodule Seeder.ModuloPesquisa.Categoria do
  alias Pescarte.ModuloPesquisa.Models.Midia.Categoria
  @behaviour Seeder.Entry

  @impl true
  def entries do
    [
      %Categoria{nome: "autoral", id_publico: Nanoid.generate_non_secure()},
      %Categoria{nome: "local", id_publico: Nanoid.generate_non_secure()},
      %Categoria{nome: "conteudo", id_publico: Nanoid.generate_non_secure()},
      %Categoria{nome: "eventos", id_publico: Nanoid.generate_non_secure()}
    ]
  end
end
