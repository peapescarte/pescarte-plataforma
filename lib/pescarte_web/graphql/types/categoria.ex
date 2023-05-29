defmodule PescarteWeb.GraphQL.Types.Categoria do
  use Absinthe.Schema.Notation

  alias PescarteWeb.GraphQL.Resolvers

  @desc "Representa uma Categoria de tags"
  object :categoria do
    field :name, :string
    field :id_publico, :string, name: "id"

    field :tags, list_of(:tag) do
      resolve(&Resolvers.Tag.list_categorias/3)
    end
  end
end
