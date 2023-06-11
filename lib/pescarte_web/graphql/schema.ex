defmodule PescarteWeb.GraphQL.Schema do
  use Absinthe.Schema

  alias PescarteWeb.GraphQL.Middlewares
  alias PescarteWeb.GraphQL.Resolvers
  alias PescarteWeb.GraphQL.Schema
  alias PescarteWeb.GraphQL.Types

  import_types(AbsintheErrorPayload.ValidationMessageTypes)

  import_types(Types.Scalars.Date)

  import_types(Types.Categoria)
  import_types(Types.Midia)
  import_types(Types.Tag)
  import_types(Types.User)

  import_types(Schema.Categoria)
  import_types(Schema.Midia)
  import_types(Schema.Tag)
  import_types(Schema.User)

  query do
    import_fields(:categoria_queries)
    import_fields(:midia_queries)
    import_fields(:tag_queries)
    import_fields(:usuario_queries)
  end

  mutation do
    import_fields(:tag_mutations)
    import_fields(:midia_mutations)
    import_fields(:usuario_mutations)
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
