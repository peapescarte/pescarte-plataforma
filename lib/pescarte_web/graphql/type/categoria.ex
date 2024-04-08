defmodule PescarteWeb.GraphQL.Type.Categoria do
  use Absinthe.Schema.Notation

  alias PescarteWeb.GraphQL.Resolver

  @desc "Representa uma Categoria de tags"
  object :categoria do
    field(:nome, :string)
    field(:id, :string, name: "id")

    field :tags, list_of(:tag) do
      resolve(&Resolver.Tag.list_categorias/3)
    end
  end
end
