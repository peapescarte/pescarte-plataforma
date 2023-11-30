defmodule PescarteWeb.GraphQL.Type.Tag do
  use Absinthe.Schema.Notation

  alias PescarteWeb.GraphQL.Resolver

  @desc "Representa uma Tag pertencente a uma Categoria"
  object :tag do
    field(:etiqueta, :string)
    field(:id_publico, :string, name: "id")

    field :midias, list_of(:midia) do
      resolve(&Resolver.Midia.list_tags/3)
    end

    field :categoria, :categoria do
      resolve(&Resolver.Categoria.get/3)
    end
  end
end
