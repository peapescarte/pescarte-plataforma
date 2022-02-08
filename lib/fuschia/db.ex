defmodule Fuschia.Db do
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

  @spec list(query, relationships) :: [struct]
  def list(%Ecto.Query{} = query, args \\ []) do
    query
    |> preload_all(args)
    |> Repo.all()
  end

  @spec get(query, id, relationships) :: struct | nil
  def get(%Ecto.Query{} = query, id, args \\ []) do
    query
    |> preload_all(args)
    |> Repo.get(id)
  end

  @spec get_by(query, keyword, relationships) :: struct | nil
  def get_by(%Ecto.Query{} = query, attrs, args \\ []) do
    query
    |> preload_all(args)
    |> Repo.get_by(attrs)
  end

  @spec one(query, relationships) :: struct | nil
  def one(%Ecto.Query{} = query, args \\ []) do
    query
    |> preload_all(args)
    |> Repo.one()
  end

  @spec exists?(query) :: boolean
  def exists?(%Ecto.Query{} = query) do
    Repo.exists?(query)
  end

  @spec create(module, map) :: {:ok, struct} | {:error, changeset}
  def create(schema, attrs) do
    schema
    |> Kernel.struct()
    |> schema.changeset(attrs)
    |> Repo.insert()
  end

  @spec create_with_custom_changeset(module, change_func, map) ::
          {:ok, struct} | {:error, changeset}
  def create_with_custom_changeset(schema, change_func, attrs) do
    schema
    |> Kernel.struct()
    |> change_func.(attrs)
    |> Repo.insert()
  end

  @spec update(query, change_func, id, map, relationships) :: {:ok, struct} | {:error, changeset}
  def update(%Ecto.Query{} = query, change_func, id, attrs, args \\ []) do
    with %{} = current <- get(query, id, args) do
      current
      |> change_func.(attrs)
      |> Repo.update()
    end
  end

  @spec update_struct(struct, map) :: {:ok, struct} | {:error, changeset}
  def update_struct(%mod{} = struct, attrs) do
    struct
    |> mod.changeset(attrs)
    |> Repo.update()
  end

  @spec delete(struct | changeset, keyword) :: {:ok, struct} | {:error, changeset}
  defdelegate delete(struct, opts \\ []), to: Repo, as: :delete

  @spec preload_all(query, relationships) :: query
  def preload_all(%Ecto.Query{} = query, args) do
    require Ecto.Query

    Ecto.Query.preload(query, ^args)
  end

  @spec preload_all(struct, relationships) :: struct
  def preload_all(%{} = struct, args) do
    Repo.preload(struct, args)
  end
end
