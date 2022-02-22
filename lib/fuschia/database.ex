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
  @type change_func :: (struct, map -> changeset)

  @doc """
  Lista todas as entidades existentes no banco
  dado uma query.

  Também aceita uma lista de átomos que representam
  as associações à serem pré-carregadas.

  ## Examples
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
  Obtém uma entidade existentes no banco
  dado uma query e um `id`.

  Também aceita uma lista de átomos que representam
  as associações à serem pré-carregadas.

  ## Examples
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
  Obtém uma entidade existentes no banco
  dado uma query e uma lista de parâmetros.

  Também aceita uma lista de átomos que representam
  as associações à serem pré-carregadas.

  ## Examples
     iex> get_by(Modulo.query(), [id: "id", field: "field"])
     %Modulo{}

     iex> get_by(Modulo.query(), [id: "id", field: "field"], [:relacao_1])
     %Modulo{relacao_1: nil

     iex> get_by(Modulo.query(), [id: "", field: ""])
     nil
  """
  @spec get_by(query, keyword, relationships) :: struct | nil
  def get_by(%Ecto.Query{} = query, attrs, args \\ []) do
    query
    |> preload_all(args)
    |> Repo.get_by(attrs)
  end

  @doc """
  Obtém uma entidade existentes no banco
  dado uma query. O resultado depende da
  ordenação da query.

  Também aceita uma lista de átomos que representam
  as associações à serem pré-carregadas.

  ## Examples
     iex> one(Modulo.query())
     %Modulo{}

     iex> one(Modulo.query(), [:relacao_1])
     %Modulo{relacao_1: nil

     iex> one(Modulo.query())
     nil
  """
  @spec one(query, relationships) :: struct | nil
  def one(%Ecto.Query{} = query, args \\ []) do
    query
    |> preload_all(args)
    |> Repo.one()
  end

  @doc """
  Verifica se uma entidade existe no banco
  dado uma query.

  ## Examples
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

  ## Examples
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

  ## Examples
     iex> create_with_custom_changeset(Modulo, &custom_changeset/2, params)
     {:ok, %{modulo: %Modulo{}, ...}}

     iex> create_with_custom_changeset(Modulo, %custom_changeset/2, invalid_params)
     {:error, failed_operation, failed_value, changes_so_far}
  """
  @spec create_with_custom_changeset(module, change_func, map) ::
          {:ok, struct} | {:error, changeset}
  def create_with_custom_changeset(schema, change_func, attrs) do
    with %Ecto.Changeset{valid?: true} = changeset <-
           schema |> Kernel.struct() |> change_func.(attrs),
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
  Atualiza uma entidade existente no banco
  dado uma query, uma função de changeset,
  o id e os parâmetros.

  Também aceita uma lista de átomos que representam
  as associações à serem pré-carregadas.

  Essas associações só serão pré-carregadas internamente,
  para o caso de atualizar uma associação da entidade.

  ## Examples
     iex> update(Modulo.query(), &changeset/2, "id", params)
     {:ok, %{modulo: %Modulo{}, ...}}

     iex> update(Modulo.query(), &changeset/2, "id", invalid_params)
     {:error, failed_operation, failed_value, changes_so_far}
  """
  @spec update(query, change_func, id, map, relationships) ::
          {:ok, struct} | {:error, changeset}
  def update(%Ecto.Query{} = query, change_func, id, attrs, args \\ []) do
    with %mod{} = current <- get(query, id, args),
         %Ecto.Changeset{valid?: true} = changeset <- change_func.(current, attrs),
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
  Atualiza uma entidade existente no banco
  dado um struct e os parâmetros.

  ## Examples
     iex> update_struct(%Modulo{}, params)
     {:ok, %{modulo: %Modulo{}, ...}}

     iex> update_struct(%Modulo{}, invalid_params)
     {:error, failed_operation, failed_value, changes_so_far}
  """
  @spec update_struct(struct, map) :: {:ok, struct} | {:error, changeset}
  def update_struct(%mod{} = struct, attrs) do
    with %Ecto.Changeset{valid?: true} = changeset <- mod.changeset(struct, attrs),
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

  ## Examples
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

  @doc """
  Pré-carrega as associações de um struct ou
  query dado uma lista de associações.

  ## Examples
     iex> preload_all(Modulo.query(), [:relacao_1])
     %Ecto.Query{}

     iex> preload_all(%Modulo{}, [:relacao_1])
     %Modulo{relacao_1: nil}
  """
  @spec preload_all(query, relationships) :: query
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
end
