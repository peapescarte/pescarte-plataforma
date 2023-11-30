defmodule PescarteWeb.GraphQL.Schema.Tag do
  use Absinthe.Schema.Notation

  alias PescarteWeb.GraphQL.Resolver

  # Queries

  object :tag_queries do
    field :listar_tags, list_of(:tag) do
      resolve(&Resolver.Tag.list/2)
    end
  end

  # Mutations

  input_object :criar_tag_input do
    field(:etiqueta, non_null(:string))
    field(:categoria_id, non_null(:string))
  end

  input_object :atualizar_tag_input do
    field(:id, non_null(:string))
    field(:etiqueta, non_null(:string))
  end

  object :tag_mutations do
    field :criar_tag, :tag do
      arg(:input, non_null(:criar_tag_input))

      resolve(&Resolver.Tag.create/2)
    end

    field :criar_tags, list_of(:tag) do
      arg(:input, list_of(:criar_tag_input))

      resolve(&Resolver.Tag.create_multiple/2)
    end

    field :atualizar_tag, :tag do
      arg(:input, :atualizar_tag_input)

      resolve(&Resolver.Tag.update/2)
    end
  end
end
