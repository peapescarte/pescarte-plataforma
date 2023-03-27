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
    field :list_midias, list_of(:midia) do
      resolve(&Resolvers.Midia.list/2)
    end

    field :get_midia, :midia do
      arg(:id, non_null(:string))

      resolve(&Resolvers.Midia.get/2)
    end

    field :list_tags, list_of(:tag) do
      resolve(&Resolvers.Tag.list/2)
    end

    field :list_categorias, list_of(:categoria) do
      resolve(&Resolvers.Categoria.list/2)
    end

    field :list_users, list_of(:user) do
      resolve(&Resolvers.User.list/2)
    end
  end

  input_object :create_tag_input do
    field :label, non_null(:string)
    field :categoria_id, non_null(:string)
  end

  input_object :update_tag_input do
    field :id, non_null(:string)
    field :label, non_null(:string)
  end

  input_object :remove_tag_input do
    field :id, non_null(:string)
  end

  input_object :create_midia_input do
    field :filename, non_null(:string)
    field :filedate, non_null(:date)
    field :link, non_null(:string)
    field :sensible?, :boolean, name: "sensible"
    field :type, non_null(:midia_type)
    field :observation, :string
    field :alt_text, :string
    field :author_id, non_null(:string)
    field :tags, list_of(:create_tag_input)
  end

  input_object :update_midia_input do
    field :id, non_null(:string)
    field :filename, :string
    field :filedate, :date
    field :link, :string
    field :sensible?, :boolean, name: "sensible"
    field :type, :midia_type
    field :observation, :string
    field :alt_text, :string
    field :author_id, :string
    field :tags, list_of(:string)
  end

  mutation do
    field :create_tag, :tag do
      arg(:input, non_null(:create_tag_input))

      resolve(&Resolvers.Tag.create_tag/2)
    end

    field :create_tags, list_of(:tag) do
      arg(:input, list_of(:create_tag_input))

      resolve(&Resolvers.Tag.create_tags/2)
    end

    field :update_tag, :tag do
      arg(:input, :update_tag_input)

      resolve(&Resolvers.Tag.update_tag/2)
    end

    field :remove_midia_tags, list_of(:tag) do
      arg(:midia_id, non_null(:string))
      arg(:tags, list_of(:remove_tag_input))

      resolve(&Resolvers.Midia.remove_tags/2)
    end

    field :create_midia, :midia do
      arg(:input, :create_midia_input)

      resolve(&Resolvers.Midia.create_midia/2)
    end

    field :update_midia, :midia do
      arg(:input, :update_midia_input)

      resolve(&Resolvers.Midia.update_midia/2)
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
