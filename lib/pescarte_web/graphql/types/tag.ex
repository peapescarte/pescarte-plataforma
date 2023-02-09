defmodule PescarteWeb.GraphQL.Types.Tag do
  use Absinthe.Schema.Notation

  alias PescarteWeb.GraphQL.Resolvers

  @desc "Representa uma Tag pertencente a uma Categoria"
  object :tag do
    field :label, :string
    field :public_id, :string, name: "id"

    field :midias, list_of(:midia) do
      resolve(&Resolvers.Midia.list_tags/3)
    end

    field :categoria, :categoria do
      resolve(&Resolvers.Categoria.get/3)
    end
  end
end
