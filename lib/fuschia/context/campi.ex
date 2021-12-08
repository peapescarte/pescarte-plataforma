defmodule Fuschia.Context.Campi do
  @moduledoc """
  Public Fuschia Campus API
  """

  import Ecto.Query

  alias Fuschia.Entities.{Campus, Cidade}
  alias Fuschia.Repo

  @spec list :: [%Campus{}]
  def list do
    query()
    |> preload_all()
    |> Repo.all()
  end

  @spec list_by_municipio(String.t()) :: [%Campus{}]
  def list_by_municipio(municipio) do
    query()
    |> join(:inner, [campus], c in Cidade, on: campus.cidade_municipio == c.municipio)
    |> where([campus], campus.cidade_municipio == ^municipio)
    |> preload_all()
    |> Repo.all()
  end

  @spec one(String.t()) :: %Campus{} | nil
  def one(nome) do
    query()
    |> preload_all()
    |> Repo.get(nome)
  end

  @spec create_with_cidade(map) :: {:ok, %Campus{}} | {:error, %Ecto.Changeset{}}
  def create_with_cidade(attrs) do
    with {:ok, campus} <-
           %Campus{}
           |> Campus.changeset(attrs)
           |> Repo.insert() do
      {:ok, preload_all(campus)}
    end
  end

  @spec create(map) :: {:ok, %Campus{}} | {:error, %Ecto.Changeset{}}
  def create(attrs) do
    with {:ok, campus} <-
           %Campus{}
           |> Campus.foreign_changeset(attrs)
           |> Repo.insert() do
      {:ok, preload_all(campus)}
    end
  end

  @spec update(String.t(), map) :: {:ok, %Campus{}} | {:error, %Ecto.Changeset{}}
  def update(nome, %{nome: _} = attrs) do
    with %Campus{} = campus <- one(nome),
         {:ok, updated} <-
           campus
           |> Campus.changeset(attrs)
           |> Repo.update() do
      {:ok, updated}
    end
  end

  @spec query :: %Ecto.Query{}
  def query do
    from campus in Campus,
      order_by: [desc: campus.created_at]
  end

  @spec preload_all(%Ecto.Query{}) :: %Ecto.Query{}
  def preload_all(%Ecto.Query{} = query) do
    Ecto.Query.preload(query, [:pesquisadores, cidade: [:campi]])
  end

  @spec preload_all(%Campus{}) :: %Campus{}
  def preload_all(%Campus{} = campus) do
    Repo.preload(campus, [:pesquisadores, cidade: [:campi]])
  end
end
