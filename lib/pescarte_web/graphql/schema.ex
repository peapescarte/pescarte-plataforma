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
    field :midias, list_of(:midia) do
      resolve(&Resolvers.Midia.list/2)
    end

    field :users, list_of(:user) do
      resolve(&Resolvers.User.list/2)
    end
  end

  input_object :tag_input do
    field :label, non_null(:string)
    field :categoria_id, non_null(:string)
  end

  mutation do
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
