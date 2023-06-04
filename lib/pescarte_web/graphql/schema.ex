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
    field :listar_midias, list_of(:midia) do
      resolve(&Resolvers.Midia.list/2)
    end

    field :buscar_midia, :midia do
      arg(:id, non_null(:string))

      resolve(&Resolvers.Midia.get/2)
    end

    field :listar_tags, list_of(:tag) do
      resolve(&Resolvers.Tag.list/2)
    end

    field :listar_categorias, list_of(:categoria) do
      resolve(&Resolvers.Categoria.list/2)
    end

    field :listar_usuarios, list_of(:user) do
      resolve(&Resolvers.User.list/2)
    end
  end

  input_object :criar_tag_input do
    field :etiqueta, non_null(:string)
    field :categoria_id, non_null(:string)
  end

  input_object :atualizar_tag_input do
    field :id, non_null(:string)
    field :etiqueta, non_null(:string)
  end

  input_object :remove_tag_input do
    field :id, non_null(:string)
  end

  input_object :criar_midia_input do
    field :nome_arquivo, non_null(:string)
    field :data_arquivo, non_null(:date)
    field :link, non_null(:string)
    field :restrito?, :boolean, name: "restrito"
    field :tipo, non_null(:midia_type)
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
    field :tipo, :midia_type
    field :observacao, :string
    field :texto_alternativo, :string
    field :autor_id, :string
    field :tags, list_of(:string)
  end

  mutation do
    field :criar_tag, :tag do
      arg(:input, non_null(:criar_tag_input))

      resolve(&Resolvers.Tag.create/2)
    end

    field :criar_tags, list_of(:tag) do
      arg(:input, list_of(:criar_tag_input))

      resolve(&Resolvers.Tag.create_multiple/2)
    end

    field :atualizar_tag, :tag do
      arg(:input, :atualizar_tag_input)

      resolve(&Resolvers.Tag.update/2)
    end

    field :remove_midia_tags, list_of(:tag) do
      arg(:midia_id, non_null(:string))
      arg(:tags, list_of(:remove_tag_input))

      resolve(&Resolvers.Midia.remove_tags/2)
    end

    field :criar_midia, :midia do
      arg(:input, :criar_midia_input)

      resolve(&Resolvers.Midia.create/2)
    end

    field :atualizar_midia, :midia do
      arg(:input, :atualizar_midia_input)

      resolve(&Resolvers.Midia.update/2)
    end

    field :login, :login do
      arg(:cpf, non_null(:string))
      arg(:senha, non_null(:string))

      resolve(&Resolvers.Login.resolve/2)
    end
  end

  # if it's any other object keep things as is
  def middleware(middleware, _field, object) do
    middleware = [Middlewares.EnsureAuthentication | middleware]

    case object do
      %{identifier: :mutation} -> [Middlewares.HandleChangesetErrors | middleware]
      _ -> middleware
    end
  end
end
