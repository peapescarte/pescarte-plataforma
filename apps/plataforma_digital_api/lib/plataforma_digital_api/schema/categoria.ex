defmodule PlataformaDigitalAPI.Schema.Categoria do
  use Absinthe.Schema.Notation

  alias PlataformaDigitalAPI.Resolver

  # Queries

  @desc "Listagem de Categorias"
  object :categoria_queries do
    field :listar_categorias, list_of(:categoria) do
      resolve(&Resolver.Categoria.list/2)
    end
  end
end
