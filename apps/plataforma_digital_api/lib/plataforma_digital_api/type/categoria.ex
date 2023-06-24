defmodule PlataformaDigitalAPI.Type.Categoria do
  use Absinthe.Schema.Notation

  alias PlataformaDigitalAPI.Resolver

  @desc "Representa uma Categoria de tags"
  object :categoria do
    field(:nome, :string)
    field(:id_publico, :string, name: "id")

    field :tags, list_of(:tag) do
      resolve(&Resolver.Tag.list_categorias/3)
    end
  end
end
