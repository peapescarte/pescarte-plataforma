defmodule PlataformaDigitalAPI.Schema.Midia do
  use Absinthe.Schema.Notation

  alias PlataformaDigitalAPI.Resolver

  # Queries

  object :midia_queries do
    field :listar_midias, list_of(:midia) do
      resolve(&Resolver.Midia.list/2)
    end

    field :buscar_midia, :midia do
      arg(:id, non_null(:string))

      resolve(&Resolver.Midia.get/2)
    end
  end

  # Mutations

  input_object :adiciona_tag_input do
    field(:midia_id, non_null(:string))
    field(:tags_id, list_of(:string))
  end

  input_object :remove_tag_input do
    field(:midia_id, non_null(:string))
    field(:tags_id, list_of(:string))
  end

  input_object :criar_midia_input do
    field(:nome_arquivo, non_null(:string))
    field(:data_arquivo, non_null(:date))
    field(:link, non_null(:string))
    field(:restrito?, :boolean, name: "restrito")
    field(:tipo, non_null(:tipo_midia_enum))
    field(:observacao, :string)
    field(:texto_alternativo, :string)
    field(:autor_id, non_null(:string))
    field(:tags, list_of(:criar_tag_input))
  end

  input_object :atualizar_midia_input do
    field(:id, non_null(:string))
    field(:nome_arquivo, :string)
    field(:data_arquivo, :date)
    field(:link, :string)
    field(:restrito?, :boolean, name: "restrito")
    field(:tipo, :tipo_midia_enum)
    field(:observacao, :string)
    field(:texto_alternativo, :string)
    field(:autor_id, :string)
  end

  object :midia_mutations do
    field :adiciona_midia_tags, list_of(:tag) do
      arg(:input, :adiciona_tag_input)

      resolve(&Resolver.Midia.adiciona_tags/2)
    end

    field :remove_midia_tags, list_of(:tag) do
      arg(:input, :remove_tag_input)

      resolve(&Resolver.Midia.remove_tags/2)
    end

    field :criar_midia, :midia do
      arg(:input, :criar_midia_input)

      resolve(&Resolver.Midia.create/2)
    end

    field :atualizar_midia, :midia do
      arg(:input, :atualizar_midia_input)

      resolve(&Resolver.Midia.update/2)
    end
  end
end
