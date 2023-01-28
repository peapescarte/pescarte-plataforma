defmodule PescarteWeb.GraphQL.Schema do
  use Absinthe.Schema

  alias PescarteWeb.GraphQL.Middlewares
  alias PescarteWeb.GraphQL.Resolvers
  alias PescarteWeb.GraphQL.Types

  import_types(Types.Scalars.Date)

  import_types(Types.Auth)
  import_types(Types.Categoria)
  import_types(Types.Midia)
  import_types(Types.Tag)

  query do
    field :categorias, list_of(:categoria) do
      resolve(&Resolvers.Categoria.list/2)
    end

    field :midias, list_of(:midia) do
      resolve(&Resolvers.Midia.list/2)
    end
  end

  input_object :tag_input do
    field :label, non_null(:string)
    field :categoria_id, non_null(:string)
  end

  mutation do
    field :categoria, :categoria do
      arg(:name, non_null(:string))

      resolve(&Resolvers.Categoria.create_categoria/2)
    end

    field :tag, :tag do
      arg(:label, non_null(:string))
      arg(:categoria_id, non_null(:string))

      resolve(&Resolvers.Tag.create_tag/2)
    end

    field :midia, :midia do
      arg(:filename, non_null(:string))
      arg(:filedate, non_null(:date))
      arg(:link, non_null(:string))
      arg(:sensible?, :boolean, name: "sensible")
      arg(:type, non_null(:midia_type))
      arg(:observation, :string)
      arg(:alt_text, :string)
      arg(:pesquisador_id, non_null(:string))
      arg(:tags, list_of(:tag_input))

      resolve(&Resolvers.Midia.create_midia/2)
    end

    field :login, :login do
      arg(:cpf, non_null(:string))
      arg(:password, non_null(:string))

      resolve(&Resolvers.Login.resolve/2)
    end
  end

  # if it's any other object keep things as is
  def middleware(middleware, _field, object) do
    middleware = [Middlewares.EnsureAuthentication | middleware]

    case object do
      %{identifier: :mutation} -> middleware ++ [Middlewares.HandleChangesetErrors]
      _ -> middleware
    end
  end
end
