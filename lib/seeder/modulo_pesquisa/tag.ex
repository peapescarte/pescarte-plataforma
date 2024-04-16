defmodule Seeder.ModuloPesquisa.Tag do
  alias Pescarte.Database.Repo
  alias Pescarte.ModuloPesquisa.Models.Midia.Categoria
  alias Pescarte.ModuloPesquisa.Models.Midia.Tag
  @behaviour Seeder.Entry

  defp categoria_id_by(nome: nome) do
    categoria = Repo.get_by(Categoria, nome: nome)
    categoria.id
  end

  @impl true
  def entries do
    [
      %Tag{
        etiqueta: "fulano_da_silva",
        categoria_id: categoria_id_by(nome: "autoral")
      },
      %Tag{
        etiqueta: "redes",
        categoria_id: categoria_id_by(nome: "conteudo")
      },
      %Tag{
        etiqueta: "peixes",
        categoria_id: categoria_id_by(nome: "conteudo")
      },
      %Tag{
        etiqueta: "mar",
        categoria_id: categoria_id_by(nome: "conteudo")
      },
      %Tag{
        etiqueta: "barco",
        categoria_id: categoria_id_by(nome: "conteudo")
      }
    ]
  end
end
