defmodule PescarteWeb.GraphQL.Schema.Midia do
  use Absinthe.Schema.Notation

  import AbsintheErrorPayload.Payload

  alias PescarteWeb.GraphQL.Resolvers

  # Queries

  payload_object(:listagem_midia_payload, list_of(:midia))
  payload_object(:buscar_midia_payload, :midia)

  object :midia_queries do
    field :listar_midias, type: :listagem_midia_payload do
      resolve(&Resolvers.Midia.list/2)
      middleware(&build_payload/2)
    end

    field :buscar_midia, type: :buscar_midia_payload do
      arg(:id, non_null(:string))

      resolve(&Resolvers.Midia.get/2)
      middleware(&build_payload/2)
    end
  end

  # Mutations

  input_object :remove_tag_input do
    field :midia_id, non_null(:string)
    field :tags_id, list_of(:string)
  end

  input_object :criar_midia_input do
    field :nome_arquivo, non_null(:string)
    field :data_arquivo, non_null(:date)
    field :link, non_null(:string)
    field :restrito?, :boolean, name: "restrito"
    field :tipo, non_null(:tipo_midia_enum)
    field :observacao, :string
    field :texto_alternativo, :string
    field :autor_id, non_null(:string)
    field :tags, list_of(:criar_tag_input)
  end

  input_object :atualizar_midia_input do
    field :id, non_null(:string)
    field :nome_arquivo, :string
    field :data_arquivo, :date
    field :link, :string
    field :restrito?, :boolean, name: "restrito"
    field :tipo, :tipo_midia_enum
    field :observacao, :string
    field :texto_alternativo, :string
    field :autor_id, :string
    field :tags, list_of(:string)
  end

  payload_object(:midia_payload, :midia)
  payload_object(:remove_tag_payload, list_of(:tag))

  object :midia_mutations do
    field :remove_midia_tags, type: :remove_tag_payload do
      arg(:input, :remove_tag_input)

      resolve(&Resolvers.Midia.remove_tags/2)
      middleware(&build_payload/2)
    end

    field :criar_midia, type: :midia_payload do
      arg(:input, :criar_midia_input)

      resolve(&Resolvers.Midia.create/2)
      middleware(&build_payload/2)
    end

    field :atualizar_midia, type: :midia_payload do
      arg(:input, :atualizar_midia_input)

      resolve(&Resolvers.Midia.update/2)
      middleware(&build_payload/2)
    end
  end
end
