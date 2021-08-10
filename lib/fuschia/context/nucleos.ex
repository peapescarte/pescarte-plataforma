defmodule Fuschia.Context.Nucleos do
  @moduledoc """
  Public Fuschia Nucleo API
  """

  import Ecto.Query

  alias Fuschia.Entities.Nucleo
  alias Fuschia.Repo

  @spec list :: [%Nucleo{}]
  def list do
    query()
    |> preload_all()
    |> Repo.all()
  end

  @spec one(String.t()) :: %Nucleo{} | nil
  def one(nome) do
    query()
    |> preload_all()
    |> Repo.get(nome)
  end

  @spec create(map) :: {:ok, %Nucleo{}} | {:error, %Ecto.Changeset{}}
  def create(attrs) do
    with {:ok, nucleo} <-
           %Nucleo{}
           |> Nucleo.changeset(attrs)
           |> Repo.insert() do
      {:ok, preload_all(nucleo)}
    end
  end

  @spec update(String.t(), map) :: {:ok, %Nucleo{}} | {:error, %Ecto.Changeset{}}
  def update(nome, attrs) do
    with %Nucleo{} = nucleo <- one(nome),
         {:ok, updated} <-
           nucleo
           |> Nucleo.changeset(attrs)
           |> Repo.update() do
      {:ok, updated}
    end
  end

  @spec query :: %Ecto.Query{}
  def query do
    from n in Nucleo,
      order_by: [desc: n.created_at]
  end

  @spec preload_all(%Ecto.Query{}) :: %Ecto.Query{}
  def preload_all(%Ecto.Query{} = query) do
    query
    |> Ecto.Query.preload([:linhas_pesquisa])
  end

  @spec preload_all(%Nucleo{}) :: %Nucleo{}
  def preload_all(%Nucleo{} = nucleo) do
    nucleo
    |> Repo.preload([:linhas_pesquisa])
  end
end
