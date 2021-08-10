defmodule Fuschia.Context.Cidades do
  @moduledoc """
  Public Fuschia Cidade API
  """

  import Ecto.Query

  alias Fuschia.Entities.Cidade
  alias Fuschia.Repo

  @spec list :: [%Cidade{}]
  def list do
    query()
    |> preload_all()
    |> Repo.all()
  end

  @spec one(String.t()) :: %Cidade{} | nil
  def one(municipio) do
    query()
    |> preload_all()
    |> Repo.get(municipio)
  end

  @spec create(map) :: {:ok, %Cidade{}} | {:error, %Ecto.Changeset{}}
  def create(attrs) do
    with {:ok, cidade} <-
           %Cidade{}
           |> Cidade.changeset(attrs)
           |> Repo.insert() do
      {:ok, preload_all(cidade)}
    end
  end

  @spec update(String.t(), map) :: {:ok, %Cidade{}} | {:error, %Ecto.Changeset{}}
  def update(nome, attrs) do
    with %Cidade{} = cidade <- one(nome),
         {:ok, updated} <-
           cidade
           |> Cidade.changeset(attrs)
           |> Repo.update() do
      {:ok, updated}
    end
  end

  @spec query :: %Ecto.Query{}
  def query do
    from u in Cidade,
      order_by: [desc: u.created_at]
  end

  @spec preload_all(%Ecto.Query{}) :: %Ecto.Query{}
  def preload_all(%Ecto.Query{} = query) do
    query
    |> Ecto.Query.preload([:universidades])
  end

  @spec preload_all(%Cidade{}) :: %Cidade{}
  def preload_all(%Cidade{} = cidade) do
    cidade
    |> Repo.preload([:universidades])
  end
end
