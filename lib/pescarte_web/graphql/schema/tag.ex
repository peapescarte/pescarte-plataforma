defmodule PescarteWeb.GraphQL.Schema.Tag do
  use Absinthe.Schema.Notation

  import AbsintheErrorPayload.Payload

  alias PescarteWeb.GraphQL.Resolvers

  # Queries

  payload_object(:listagem_tags_payload, list_of(:tag))

  object :tag_queries do
    field :listar_tags, type: :listagem_tags_payload do
      resolve(&Resolvers.Tag.list/2)
      middleware(&build_payload/2)
    end
  end

  # Mutations

  input_object :criar_tag_input do
    field :etiqueta, non_null(:string)
    field :categoria_id, non_null(:string)
  end

  input_object :atualizar_tag_input do
    field :id, non_null(:string)
    field :etiqueta, non_null(:string)
  end

  payload_object(:tag_payload, :tag)
  payload_object(:tags_payload, list_of(:tag))

  object :tag_mutations do
    field :criar_tag, type: :tag_payload do
      arg(:input, non_null(:criar_tag_input))

      resolve(&Resolvers.Tag.create/2)
      middleware(&build_payload/2)
    end

    field :criar_tags, type: :tags_payload do
      arg(:input, list_of(:criar_tag_input))

      resolve(&Resolvers.Tag.create_multiple/2)
      middleware(&build_payload/2)
    end

    field :atualizar_tag, type: :tag_payload do
      arg(:input, :atualizar_tag_input)

      resolve(&Resolvers.Tag.update/2)
      middleware(&build_payload/2)
    end
  end
end
