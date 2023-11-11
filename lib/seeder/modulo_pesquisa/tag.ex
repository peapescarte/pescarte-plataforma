defmodule Seeder.ModuloPesquisa.Tag do
  alias Pescarte.ModuloPesquisa.Models.Midia.Tag

  @behaviour Seeder.Entry

  @impl true
  def entries do
    [
      %Tag{
        etiqueta: "fulano_da_silva",
        categoria_nome: "autoral",
        id_publico: Nanoid.generate_non_secure()
      },
      %Tag{
        etiqueta: "redes",
        categoria_nome: "conteudo",
        id_publico: Nanoid.generate_non_secure()
      },
      %Tag{
        etiqueta: "peixes",
        categoria_nome: "conteudo",
        id_publico: Nanoid.generate_non_secure()
      },
      %Tag{
        etiqueta: "mar",
        categoria_nome: "conteudo",
        id_publico: Nanoid.generate_non_secure()
      },
      %Tag{
        etiqueta: "barco",
        categoria_nome: "conteudo",
        id_publico: Nanoid.generate_non_secure()
      }
    ]
  end
end
