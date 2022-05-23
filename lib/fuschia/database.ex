defmodule Fuschia.Database do
  @moduledoc """
  Este módulo centraliza os efeitos colaterais
  do banco de dados.

  Fontes: https://pt.stackoverflow.com/questions/330341/o-que-s%C3%A3o-efeitos-colaterais
  """

  alias Fuschia.Repo

  @type id :: integer | binary
  @type query :: Ecto.Query.t()
  @type changeset :: Ecto.Changeset.t()
  @type relationships :: keyword
  @type change_fun :: (struct, map -> changeset)

  @doc """
  Lista todas as entidades existentes no banco
  dado uma query.

  Também aceita uma lista de átomos que representam
  as associações à serem pré-carregadas.

  ## Exemplos
       iex> list(Modulo.query())
       [%Modulo{}]

       iex> list(Modulo.query(), [:relacao_1])
       [%Modulo{relacao_1: nil]
  """
  @spec list(query, relationships) :: [struct]
  def list(%Ecto.Query{} = query, args \\ []) do
    query
    |> preload_all(args)
    |> Repo.all()
  end

  @doc """
  Mesmo que `list/2` porém abstrai a ideia do módulo
  de queries, recebendo-o via opções. Ao invés de receber
  uma `%Ecto.Query{}` diretamente, recebe um módulo que
  define uma entidade.

  ## Opções
  * `queries_mod` - define qual o módulo de queries será usado
    para recuperar os relacionamentos de uma entidade.
  * `query_fun` - define qual função do módulo de queries deverá
    ser executada.
  * `query_args` - define os argumentos que serão passados para
    a função definida pela opção `query_fun`

  ## Exemplos
       iex> list_entity(Modulo, queries_mod: Queries)
       [%Modulo{}]

       iex> list_entity(Modulo, queries_mod: Queries)
       [%Modulo{relacao_1: nil]
  """
  @spec list_entity(module, keyword) :: [struct]
  def list_entity(source, opts) do
    queries_mod = get_queries_mod(opts, source)
    query_fun = Keyword.get(opts, :query_fun) || :query
    query_args = get_query_args(opts)

    queries_mod
    |> apply(query_fun, query_args)
    |> list(queries_mod.relationships())
  end

  @doc """
  Obtém uma entidade existentes no banco
  dado uma query e um `id`.

  Também aceita uma lista de átomos que representam
  as associações à serem pré-carregadas.

  ## Exemplos
       iex> get(Modulo.query(), "id")
       %Modulo{}

       iex> get(Modulo.query(), "id", [:relacao_1])
       %Modulo{relacao_1: nil

       iex> get(Modulo.query(), "")
       nil
  """
  @spec get(query, id, relationships) :: struct | nil
  def get(%Ecto.Query{} = query, id, args \\ []) do
    query
    |> preload_all(args)
    |> Repo.get(id)
  end

  @doc """
  Mesmo que `get/2` e `get/3` porém abstrai a ideia do módulo
  de queries, recebendo-o via opções. Ao invés de receber
  uma `%Ecto.Query{}` diretamente, recebe um módulo que
  define uma entidade.

  ## Opções
  * `queries_mod` - define qual o módulo de queries será usado
    para recuperar os relacionamentos de uma entidade.
  * `query_fun` - define qual função do módulo de queries deverá
    ser executada.
  * `query_args` - define os argumentos que serão passados para
    a função definida pela opção `query_fun`

  ## Exemplos
       iex> get_entity(Modulo, "id", queries_mod: Queries)
       %Modulo{}

       iex> get(Modulo, "id", queries_mod: Queries)
       %Modulo{relacao_1: nil

       iex> get(Modulo.query(), "", queries_mod: Queries)
       nil
  """
  @spec get_entity(module, id, keyword) :: struct | nil
  def get_entity(source, id, opts) do
    queries_mod = get_queries_mod(opts, source)
    query_fun = Keyword.get(opts, :query_fun) || :query
    query_args = get_query_args(opts)

    queries_mod
    |> apply(query_fun, query_args)
    |> get(id, queries_mod.relationships())
  end

  @doc """
  Obtém uma entidade existentes no banco
  dado uma query e uma lista de parâmetros.

  Também aceita uma lista de átomos que representam
  as associações à serem pré-carregadas.

  ## Exemplos
       iex> get_by(Modulo.query(), [id: "id", field: "field"])
       %Modulo{}

       iex> get_by(Modulo.query(), [:relacao_1], [id: "id", field: "field"])
       %Modulo{relacao_1: nil}

       iex> get_by(Modulo.query(), [id: "", field: ""])
       nil
  """
  @spec get_by(query, relationships, keyword) :: struct | nil
  def get_by(%Ecto.Query{} = query, args \\ [], attrs) do
    query
    |> preload_all(args)
    |> Repo.get_by(attrs)
  end

  @doc """
  Mesmo que `get_by/2` e `get_by/3` porém abstrai a ideia do módulo
  de queries, recebendo-o via opções. Ao invés de receber
  uma `%Ecto.Query{}` diretamente, recebe um módulo que
  define uma entidade.

  ## Opções
  * `queries_mod` - define qual o módulo de queries será usado
    para recuperar os relacionamentos de uma entidade.
  * `query_fun` - define qual função do módulo de queries deverá
    ser executada.
  * `query_args` - define os argumentos que serão passados para
    a função definida pela opção `query_fun`

  ## Exemplos
       iex> get_entity_by(Modulo, [id: "id", field: "field"], queries_mod: Queries)
       %Modulo{}

       iex> get_entity_by(Modulo, [id: "id", field: "field"], queries_mod: Queries)
       %Modulo{relacao_1: nil}

       iex> get_entity_by(Modulo, [id: "", field: ""], queries_mod: Queries)
       nil
  """
  @spec get_entity_by(module, keyword, keyword) :: struct | nil
  def get_entity_by(source, args, opts) do
    queries_mod = get_queries_mod(opts, source)
    query_fun = Keyword.get(opts, :query_fun) || :query
    query_args = get_query_args(opts)

    queries_mod
    |> apply(query_fun, query_args)
    |> get_by(queries_mod.relationships(), args)
  end

  @doc """
  Obtém uma entidade existentes no banco
  dado uma query. O resultado depende da
  ordenação da query.

  ## Exemplos
       iex> one(Modulo.query())
       %Modulo{}

       iex> one(Modulo.query())
       nil
  """
  defdelegate one(query), to: Repo

  @doc """
  Obtém uma entidade existentes no banco
  dado uma query. O resultado depende da
  ordenação da query.

  Também aceita uma lista de átomos que representam
  as associações à serem pré-carregadas.

  ## Exemplos
       iex> one(Modulo.query())
       %Modulo{}

       iex> one(Modulo.query(), [:relacao_1])
       %Modulo{relacao_1: nil

       iex> one(Modulo.query())
       nil
  """
  @spec one(query, relationships) :: struct | nil
  def one(%Ecto.Query{} = query, args) do
    query
    |> preload_all(args)
    |> Repo.one()
  end

  @doc """
  Verifica se uma entidade existe no banco
  dado uma query.

  ## Exemplos
       iex> exists?(Modulo.query())
       true

       iex> exists?(Modulo.query())
       false
  """
  @spec exists?(query) :: boolean
  def exists?(%Ecto.Query{} = query) do
    Repo.exists?(query)
  end

  @doc """
  Insere uma entidade no banco dado um módulo
  e os parâmetros.

  ## Exemplos
       iex> create(Modulo, params)
       {:ok, %{modulo: %Modulo{}, ...}}

       iex> create(Modulo, invalid_params)
       {:error, failed_operation, failed_value, changes_so_far}
  """
  @spec create(module, map) :: {:ok, struct} | {:error, changeset}
  def create(schema, attrs) do
    create_with_custom_changeset(schema, &schema.changeset/2, attrs)
  end

  @doc """
  Mesmo que `Fuschia.Database.create/2` porém aceita uma função
  de `changeset/2` customizada como segundo parâmetro.

  ## Exemplos
       iex> create_with_custom_changeset(Modulo, &custom_changeset/2, params)
       {:ok, %{modulo: %Modulo{}, ...}}

       iex> create_with_custom_changeset(Modulo, %custom_changeset/2, invalid_params)
       {:error, failed_operation, failed_value, changes_so_far}
  """
  @spec create_with_custom_changeset(module, change_fun, map) ::
          {:ok, struct} | {:error, changeset}
  def create_with_custom_changeset(schema, change_fun, attrs) do
    with %Ecto.Changeset{valid?: true} = changeset <-
           schema |> Kernel.struct() |> change_fun.(attrs),
         %{meta: meta, source: source} = build_meta(schema, "insert"),
         {:ok, changes} <-
           Ecto.Multi.new()
           |> Carbonite.Multi.insert_transaction(meta)
           |> Ecto.Multi.insert(source, changeset)
           |> Repo.transaction() do
      {:ok, Map.get(changes, source)}
    else
      %Ecto.Changeset{} = changeset -> {:error, changeset}
      err -> err
    end
  end

  @doc """
  Mesmo que `create/2` e `create_with_custom_changeset/3` porém abstrai
  a ideia do módulo de queries, recebendo-o via opções. Ao invés de receber
  uma `%Ecto.Query{}` diretamente, recebe um módulo que
  define uma entidade. Também pré-carrega todas os relacionamentos.

  ## Opções
  * `queries_mod` - define qual o módulo de queries será usado
    para recuperar os relacionamentos de uma entidade.
  * `change_fun` - define qual função de changeset será usada.
    O valor padrão é `Modulo.changeset/2`.

  ## Exemplos
       iex> cretae_and_preload(Modulo, params, queries_mod: Queries)
       {:ok, %Modulo{}}

       iex> create_and_preload(Modulo, invalid_params, queries_mod: Queries)
       {:error, failed_operation, failed_value, changes_so_far}
  """
  @spec create_and_preload(module, map, keyword) :: {:ok, struct} | {:error, changeset}
  def create_and_preload(source, attrs, opts) do
    entity_query_mod = get_queries_mod(opts, source)
    change_fun = Keyword.get(opts, :change_fun, :changeset)

    create_fun =
      if change_fun == :changeset,
        do: &create(source, &1),
        else: &create_with_custom_changeset(source, change_fun, &1)

    with {:ok, entity} <- create_fun.(attrs),
         %^source{} = preloaded <-
           preload_all(entity, entity_query_mod.relationships()) do
      {:ok, preloaded}
    end
  end

  @doc """
  Atualiza uma entidade existente no banco
  dado um struct e os parâmetros.

  Também é possível passar uma função de changeset
  customizada, em formato de átomo.

  ## Exemplos
     iex> update(%Modulo{}, params)
     {:ok, %{modulo: %Modulo{}, ...}}

     iex> update(%Modulo{}, params, :update_changeset)
     {:ok, %{modulo: %Modulo{}, ...}}

     iex> update(%Modulo{}, invalid_params)
     {:error, failed_operation, failed_value, changes_so_far}
  """
  @spec update(struct, map) :: {:ok, struct} | {:error, changeset}
  def update(%mod{} = struct, attrs, change_fun \\ :changeset) do
    change_fun = if change_fun == :changeset, do: &mod.changeset/3, else: change_fun

    with %Ecto.Changeset{valid?: true} = changeset <-
           change_fun.(struct, attrs),
         %{meta: meta, source: source} = build_meta(mod, "update"),
         {:ok, changes} <-
           Ecto.Multi.new()
           |> Carbonite.Multi.insert_transaction(meta)
           |> Ecto.Multi.update(source, changeset)
           |> Repo.transaction() do
      {:ok, Map.get(changes, source)}
    else
      %Ecto.Changeset{} = changeset -> {:error, changeset}
      err -> err
    end
  end

  @doc """
  Mesmo que `update/2` e `update/3` porém abstrai a ideia do
  módulo de queries, recebendo-o via opções. Ao invés de receber
  uma `%Ecto.Query{}` diretamente, recebe um módulo que
  define uma entidade. Também pré-carrega todas os relacionamentos.

  ## Opções
  * `queries_mod` - define qual o módulo de queries será usado
    para recuperar os relacionamentos de uma entidade.
  * `change_fun` - define qual função de changeset será usada.
    O valor padrão é `Modulo.changeset/2`.

  ## Exemplos
     iex> update_and_preload(%Modulo{}, params, queries_mod: Queries)
     {:ok, %{modulo: %Modulo{}, ...}}

     iex> update(%Modulo{}, params, queries_mod: Queries, change_fun: :update_changeset)
     {:ok, %{modulo: %Modulo{}, ...}}

     iex> update(%Modulo{}, invalid_params, queries_mod: Queries)
     {:error, failed_operation, failed_value, changes_so_far}
  """
  @spec update_and_preload(struct, map, keyword) :: {:ok, struct} | {:error, changeset}
  def update_and_preload(%source{} = struct, attrs, opts) do
    entity_query_mod = get_queries_mod(opts, source)
    change_fun = Keyword.get(opts, :change_fun, :changeset)

    with {:ok, entity} <- update(struct, attrs, change_fun),
         ^struct = preloaded <-
           preload_all(entity, entity_query_mod.relationships()) do
      {:ok, preloaded}
    end
  end

  @spec insert(changeset | struct, list) :: {:ok, struct} | {:error, changeset}
  def insert(source, opts \\ [])

  def insert(%Ecto.Changeset{data: %mod{}} = changeset, opts) do
    %{meta: meta, source: source} = build_meta(mod, "insert")

    Ecto.Multi.new()
    |> Carbonite.Multi.insert_transaction(meta)
    |> Ecto.Multi.insert(source, changeset, opts)
    |> Repo.transaction()
    |> case do
      {:ok, changes} -> {:ok, Map.get(changes, source)}
      err -> err
    end
  end

  def insert(%mod{} = struct, opts) do
    %{meta: meta, source: source} = build_meta(mod, "insert")

    Ecto.Multi.new()
    |> Carbonite.Multi.insert_transaction(meta)
    |> Ecto.Multi.insert(source, struct, opts)
    |> Repo.transaction()
    |> case do
      {:ok, changes} -> {:ok, Map.get(changes, source)}
      err -> err
    end
  end

  @spec insert_or_update(struct, list) :: {:ok, struct} | {:error, changeset}
  def insert_or_update(%mod{} = struct, opts \\ []) do
    %{meta: meta, source: source} = build_meta(mod, "insert_or_update")

    Ecto.Multi.new()
    |> Carbonite.Multi.insert_transaction(meta)
    |> Ecto.Multi.insert_or_update(source, struct, opts)
    |> Repo.transaction()
    |> case do
      {:ok, changes} -> {:ok, Map.get(changes, source)}
      err -> err
    end
  end

  @doc """
  deleta uma entidade existente no banco
  dado um struct ou changeset.

  ## Exemplos
     iex> delete(%Modulo{})
     {:ok, %{modulo: %Modulo{}, ...}}

     iex> delete(changeset)
     {:ok, %{modulo: %Modulo{}, ...}}

     iex> delete(invalid_entity)
     {:error, failed_operation, failed_value, changes_so_far}
  """
  @spec delete(struct | changeset, keyword) :: {:ok, struct} | {:error, changeset}
  def delete(source, opts \\ [])

  def delete(%Ecto.Changeset{data: %mod{}} = changeset, opts) do
    %{meta: meta, source: source} = build_meta(mod, "delete")

    Ecto.Multi.new()
    |> Carbonite.Multi.insert_transaction(meta)
    |> Ecto.Multi.delete(source, changeset, opts)
    |> Repo.transaction()
    |> case do
      {:ok, changes} -> {:ok, Map.get(changes, source)}
      err -> err
    end
  end

  def delete(%mod{} = struct, opts) do
    %{meta: meta, source: source} = build_meta(mod, "delete")

    Ecto.Multi.new()
    |> Carbonite.Multi.insert_transaction(meta)
    |> Ecto.Multi.delete(source, struct, opts)
    |> Repo.transaction()
    |> case do
      {:ok, changes} -> {:ok, Map.get(changes, source)}
      err -> err
    end
  end

  defdelegate reload(query, opts \\ []), to: Repo

  defdelegate transaction(multi, opts \\ []), to: Repo

  defdelegate delete_all(query, opts \\ []), to: Repo

  @doc """
  Pré-carrega as associações de um struct ou
  query dado uma lista de associações.

  ## Exemplos
     iex> preload_all(Modulo.query(), [:relacao_1])
     %Ecto.Query{}

     iex> preload_all(%Modulo{}, [:relacao_1])
     %Modulo{relacao_1: nil}
  """
  @spec preload_all(query, relationships) :: query
  def preload_all(nil, _args), do: nil

  def preload_all(%Ecto.Query{} = query, args) do
    require Ecto.Query

    Ecto.Query.preload(query, ^args)
  end

  @spec preload_all(struct, relationships) :: struct
  def preload_all(%{} = struct, args) do
    Repo.preload(struct, args)
  end

  defp build_meta(module, event) do
    source = module.__schema__(:source)
    type = source <> "_" <> event

    %{meta: %{type: type}, source: source}
  end

  defp get_queries_mod(opts, mod) do
    suffix = mod |> to_string() |> String.split(".") |> List.last()

    opts
    |> Keyword.get(:queries_mod)
    |> Module.safe_concat(suffix)
  end

  defp get_query_args(opts) do
    case Keyword.get(opts, :query_args) do
      nil -> []
      args when is_list(args) -> args
      arg -> [arg]
    end
  end
end
