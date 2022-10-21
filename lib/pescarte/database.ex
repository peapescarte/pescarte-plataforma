defmodule Backend.Database do
  @moduledoc """
  Este módulo centraliza os efeitos colaterais
  do banco de dados.

  Fontes: https://pt.stackoverflow.com/questions/330341/o-que-s%C3%A3o-efeitos-colaterais
  """

  alias Backend.Repo

  @type query :: Ecto.Query.t()
  @type changeset :: Ecto.Changeset.t()
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
  defdelegate all(source), to: Repo

  @doc """
  Obtém uma entidade existentes no banco
  dado uma query e um `id`.

  ## Exemplos
       iex> get(Modulo.query(), "id")
       %Modulo{}

       iex> get(Modulo.query(), "")
       nil
  """
  defdelegate get(source, id), to: Repo

  @doc """
  Obtém uma entidade existentes no banco
  dado uma query e uma lista de parâmetros.

  ## Exemplos
       iex> get_by(Modulo.query(), [id: "id", field: "field"])
       %Modulo{}

       iex> get_by(Modulo.query(), [id: "", field: ""])
       nil
  """
  defdelegate get_by(source, params), to: Repo

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

  defdelegate insert_or_update(source), to: Repo

  defdelegate preload(source, assocs), to: Repo

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

  @spec update(changeset) :: {:ok, struct} | {:error, changeset}
  def update(%Ecto.Changeset{} = changeset) do
    %mod{} = changeset.data
    %{meta: meta, source: source} = build_meta(mod, "update")

    with {:ok, changes} <-
           carbonite_multi(&Ecto.Multi.update/3, meta, source, changeset) do
      {:ok, Map.get(changes, source)}
    end
  end

  @spec insert(changeset) :: {:ok, struct} | {:error, changeset}
  def insert(%Ecto.Changeset{} = changeset) do
    %mod{} = changeset.data
    %{meta: meta, source: source} = build_meta(mod, "insert")

    with {:ok, changes} <-
           carbonite_multi(&Ecto.Multi.insert/3, meta, source, changeset) do
      {:ok, Map.get(changes, source)}
    end
  end

  @spec insert(struct) :: {:ok, struct} | {:error, changeset}
  def insert(%mod{} = data) do
    %{meta: meta, source: source} = build_meta(mod, "insert")

    with {:ok, changes} <-
           carbonite_multi(&Ecto.Multi.insert/3, meta, source, data) do
      {:ok, Map.get(changes, source)}
    end
  end

  @doc """
  Deleta uma entidade existente no banco.

  ## Exemplos
     iex> delete(%Modulo{})
     {:ok, struct}

     iex> delete(invalid_entity)
     {:error, %Ecto.Changeset{...}}
  """
  @spec delete(struct) :: {:ok, struct} | {:error, changeset}
  def delete(%mod{} = struct) do
    %{meta: meta, source: source} = build_meta(mod, "delete")

    with {:ok, changes} <-
           carbonite_multi(&Ecto.Multi.delete/3, meta, source, struct) do
      {:ok, Map.get(changes, source)}
    end
  end

  defdelegate reload(query, opts \\ []), to: Repo

  defdelegate transaction(multi, opts \\ []), to: Repo

  defdelegate delete_all(query, opts \\ []), to: Repo

  defp carbonite_multi(fun, meta, source, changeset) do
    Ecto.Multi.new()
    |> Carbonite.Multi.insert_transaction(meta)
    |> fun.(source, changeset)
    |> Repo.transaction()
    |> case do
      {:ok, result} -> {:ok, result}
      {:error, _source, changeset, _carbo} -> {:error, changeset}
    end
  end

  defp build_meta(module, event) do
    source = module.__schema__(:source)
    type = source <> "_" <> event

    %{meta: %{type: type}, source: source}
  end
end
