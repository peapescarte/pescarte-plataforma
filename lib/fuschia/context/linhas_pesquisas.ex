defmodule Fuschia.Context.LinhasPesquisas do
  @moduledoc """
  Public Fuschia LinhaPesquisa API
  """

  import Ecto.Query

  alias Fuschia.Entities.{LinhaPesquisa, Nucleo}
  alias Fuschia.Repo

  @spec list :: [%LinhaPesquisa{}]
  def list do
    query()
    |> preload_all()
    |> Repo.all()
  end

  @spec list_by_nucleo(String.t()) :: [%LinhaPesquisa{}]
  def list_by_nucleo(nome) do
    query()
    |> join(:inner, [l], n in Nucleo, on: l.nucleo_nome == n.nome)
    |> where([l], l.nucleo_nome == ^nome)
    |> preload_all()
    |> Repo.all()
  end

  @spec one(String.t()) :: %LinhaPesquisa{} | nil
  def one(nome) do
    query()
    |> preload_all()
    |> Repo.get(nome)
  end

  @spec create(map) :: {:ok, %LinhaPesquisa{}} | {:error, %Ecto.Changeset{}}
  def create(attrs) do
    with {:ok, linha_pesquisa} <-
           %LinhaPesquisa{}
           |> LinhaPesquisa.changeset(attrs)
           |> Repo.insert() do
      {:ok, preload_all(linha_pesquisa)}
    end
  end

  @spec update(String.t(), map) :: {:ok, %LinhaPesquisa{}} | {:error, %Ecto.Changeset{}}
  def update(nome, attrs) do
    with %LinhaPesquisa{} = linha_pesquisa <- one(nome),
         {:ok, updated} <-
           linha_pesquisa
           |> LinhaPesquisa.changeset(attrs)
           |> Repo.update() do
      {:ok, updated}
    end
  end

  @spec query :: %Ecto.Query{}
  def query do
    from l in LinhaPesquisa,
      order_by: [desc: l.created_at]
  end

  @spec preload_all(%Ecto.Query{}) :: %Ecto.Query{}
  def preload_all(%Ecto.Query{} = query) do
    Ecto.Query.preload(query, nucleo: [:linhas_pesquisa])
  end

  @spec preload_all(%LinhaPesquisa{}) :: %LinhaPesquisa{}
  def preload_all(%LinhaPesquisa{} = linha_pesquisa) do
    Repo.preload(linha_pesquisa, nucleo: [:linhas_pesquisa])
  end
end
