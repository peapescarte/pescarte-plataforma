defmodule PlataformaDigitalAPI.Schema do
  use Absinthe.Schema

  alias PlataformaDigitalAPI.Middleware
  alias PlataformaDigitalAPI.Schema
  alias PlataformaDigitalAPI.Type

  import_types(Type.Scalars.Date)

  import_types(Type.Categoria)
  import_types(Type.Midia)
  import_types(Type.Tag)
  import_types(Type.User)

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

  def middleware(middleware, _field, _object) do
    middleware ++ [Middleware.EnsureAuthentication, Middleware.ErrorHandler]
  end
end
