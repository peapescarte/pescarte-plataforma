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

  @spec list(query, relationships) :: [struct]
  def list(%Ecto.Query{} = query, args \\ []) do
    query
    |> preload_all(args)
    |> Repo.all()
  end

  @spec one(query, id, relationships) :: struct | nil
  def one(%Ecto.Query{} = query, id, args \\ []) do
    query
    |> preload_all(args)
    |> Repo.get(id)
  end

  @spec create(module, map) :: {:ok, struct} | {:error, changeset}
  def create(schema, attrs) do
    schema
    |> Kernel.struct()
    |> schema.changeset(attrs)
    |> Repo.insert()
  end

  @spec update(module, map) :: {:ok, struct} | {:error, changeset}
  def update(schema, attrs) do
    schema
    |> Kernel.struct()
    |> schema.changeset(attrs)
    |> Repo.update()
  end

  @spec update_by_id(module, id, map) :: {:ok, struct} | {:error, changeset}
  def update_by_id(schema, id, attrs) do
    with %{} = current <- one(schema, id) do
      current
      |> schema.changeset(attrs)
      |> Repo.update()
    end
  end

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
