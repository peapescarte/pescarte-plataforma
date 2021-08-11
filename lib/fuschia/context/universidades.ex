defmodule Fuschia.Context.Universidades do
  @moduledoc """
  Public Fuschia Universidade API
  """

  import Ecto.Query

  alias Fuschia.Entities.{Cidade, Universidade}
  alias Fuschia.Repo

  @spec list :: [%Universidade{}]
  def list do
    query()
    |> preload_all()
    |> Repo.all()
  end

  @spec list_by_municipio(String.t()) :: [%Universidade{}]
  def list_by_municipio(municipio) do
    query()
    |> join(:inner, [u], c in Cidade, on: u.cidade_municipio == c.municipio)
    |> where([u], u.cidade_municipio == ^municipio)
    |> preload_all()
    |> Repo.all()
  end

  @spec one(String.t()) :: %Universidade{} | nil
  def one(nome) do
    query()
    |> preload_all()
    |> Repo.get(nome)
  end

  @spec create_with_cidade(map) :: {:ok, %Universidade{}} | {:error, %Ecto.Changeset{}}
  def create_with_cidade(attrs) do
    with {:ok, universidade} <-
           %Universidade{}
           |> Universidade.changeset(attrs)
           |> Repo.insert() do
      {:ok, preload_all(universidade)}
    end
  end

  @spec create(map) :: {:ok, %Universidade{}} | {:error, %Ecto.Changeset{}}
  def create(attrs) do
    with {:ok, universidade} <-
           %Universidade{}
           |> Universidade.foreign_changeset(attrs)
           |> Repo.insert() do
      {:ok, preload_all(universidade)}
    end
  end

  @spec update(String.t(), map) :: {:ok, %Universidade{}} | {:error, %Ecto.Changeset{}}
  def update(nome, %{nome: _} = attrs) do
    with %Universidade{} = universidade <- one(nome),
         {:ok, updated} <-
           universidade
           |> Universidade.changeset(attrs)
           |> Repo.update() do
      {:ok, updated}
    end
  end

  @spec query :: %Ecto.Query{}
  def query do
    from u in Universidade,
      order_by: [desc: u.created_at]
  end

  @spec preload_all(%Ecto.Query{}) :: %Ecto.Query{}
  def preload_all(%Ecto.Query{} = query) do
    query
    |> Ecto.Query.preload([:pesquisadores, cidade: [:universidades]])
  end

  @spec preload_all(%Universidade{}) :: %Universidade{}
  def preload_all(%Universidade{} = universidade) do
    universidade
    |> Repo.preload([:pesquisadores, cidade: [:universidades]])
  end
end
