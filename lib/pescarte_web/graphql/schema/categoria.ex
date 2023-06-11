defmodule PescarteWeb.GraphQL.Schema.Categoria do
  use Absinthe.Schema.Notation

  import AbsintheErrorPayload.Payload

  alias PescarteWeb.GraphQL.Resolvers

  # Queries

  payload_object(:listagem_categoria, list_of(:categoria))

  @desc "Listagem de Categorias"
  object :categoria_queries do
    field :listar_categorias, type: :listagem_categoria do
      resolve(&Resolvers.Categoria.list/2)
      middleware(&build_payload/2)
    end
  end
end
