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
  @spec list(query | module) :: [struct]
  def list(source) do
    Repo.all(source)
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
  @spec get(query | module, id, relationships) :: struct | nil
  def get(source, id, args \\ []) do
    source
    |> Repo.get(id)
    |> preload_all(args)
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
  @spec get_by(query | module, relationships, keyword) :: struct | nil
  def get_by(source, args \\ [], attrs) do
    source
    |> Repo.get_by(attrs)
    |> preload_all(args)
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
  defdelegate one(source), to: Repo

  @doc """
  Verifica se uma entidade existe no banco
  dado uma query.

  ## Exemplos
       iex> exists?(Modulo.query())
       true

       iex> exists?(Modulo.query())
       false
  """
  defdelegate exists?(query), to: Repo

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
           change_fun.(struct(schema), attrs),
         %{meta: meta, source: source} = build_meta(schema, "insert"),
         {:ok, changes} <-
           carbonite_multi(&Ecto.Multi.insert/4, meta, source, changeset) do
      {:ok, Map.get(changes, source)}
    else
      %Ecto.Changeset{} = changeset -> {:error, changeset}
    end
  end

  @spec update(struct, map) :: {:ok, struct} | {:error, changeset}
  def update(%mod{} = schema, attrs) do
    update_with_custom_changeset(schema, &mod.changeset/2, attrs)
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
  @spec update_with_custom_changeset(struct, map, change_fun) ::
          {:ok, struct} | {:error, changeset}
  def update_with_custom_changeset(%mod{} = struct, change_fun, attrs) do
    with %Ecto.Changeset{valid?: true} = changeset <-
           change_fun.(struct, attrs),
         %{meta: meta, source: source} = build_meta(mod, "update"),
         {:ok, changes} <-
           carbonite_multi(&Ecto.Multi.update/4, meta, source, changeset) do
      {:ok, Map.get(changes, source)}
    else
      %Ecto.Changeset{} = changeset -> {:error, changeset}
    end
  end

  @spec insert(struct, list) :: {:ok, struct} | {:error, changeset}
  def insert(%mod{} = struct, opts \\ []) do
    %{meta: meta, source: source} = build_meta(mod, "insert")

    with {:ok, changes} <-
           carbonite_multi(&Ecto.Multi.insert/4, meta, source, struct, opts) do
      {:ok, Map.get(changes, source)}
    end
  end

  @doc """
  Deleta uma entidade existente no banco.

  ## Exemplos
     iex> delete(%Modulo{})
     {:ok, %{modulo: %Modulo{}, ...}}

     iex> delete(changeset)
     {:ok, %{modulo: %Modulo{}, ...}}

     iex> delete(invalid_entity)
     {:error, %Ecto.Changeset{...}}
  """
  @spec delete(struct, keyword) :: {:ok, struct} | {:error, changeset}
  def delete(%mod{} = struct, opts) do
    %{meta: meta, source: source} = build_meta(mod, "delete")

    with {:ok, changes} <-
           carbonite_multi(&Ecto.Multi.delete/4, meta, source, struct, opts) do
      {:ok, Map.get(changes, source)}
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
  @spec preload_all(query | struct, relationships) :: query
  def preload_all(nil, _args), do: nil

  def preload_all(%Ecto.Query{} = query, args) do
    require Ecto.Query

    Ecto.Query.preload(query, ^args)
  end

  def preload_all(%_mod{} = struct, args) do
    Repo.preload(struct, args)
  end

  defp carbonite_multi(fun, meta, source, changeset, opts \\ []) do
    opts = if Enum.empty?(opts), do: [on_conflict: :replace], else: []

    Ecto.Multi.new()
    |> Carbonite.Multi.insert_transaction(meta)
    |> fun.(source, changeset, opts)
    |> Repo.transaction()
    |> case do
      {:error, _any} = err -> err
      {:error, _source, changeset, _carbo} -> {:error, changeset}
      ok -> ok
    end
  end

  defp build_meta(module, event) do
    source = module.__schema__(:source)
    type = source <> "_" <> event

    %{meta: %{type: type}, source: source}
  end
end
