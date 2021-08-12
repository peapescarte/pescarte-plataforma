defmodule Fuschia.Context.Pesquisadores do
  @moduledoc """
  Public Fuschia Pesquisador API
  """

  import Ecto.Query

  alias Fuschia.Entities.Pesquisador
  alias Fuschia.Repo

  @spec list :: [%Pesquisador{}]
  def list do
    query()
    |> preload_all()
    |> Repo.all()
  end

  @spec one(String.t()) :: %Pesquisador{} | nil
  def one(cpf) do
    query()
    |> preload_all()
    |> Repo.get(cpf)
  end

  @spec list_by_orientador(String.t()) :: [%Pesquisador{}]
  def list_by_orientador(orientador_cpf) do
    query()
    |> where([p], p.orientador_cpf == ^orientador_cpf)
    |> order_by([p], desc: p.created_at)
    |> preload_all()
    |> Repo.one()
  end

  @spec create(map) :: {:ok, %Pesquisador{}} | {:error, %Ecto.Changeset{}}
  def create(attrs) do
    with {:ok, pesquisador} <-
           %Pesquisador{}
           |> Pesquisador.changeset(attrs)
           |> Repo.insert() do
      {:ok, preload_all(pesquisador)}
    end
  end

  @spec update(String.t(), map) :: {:ok, %Pesquisador{}} | {:error, %Ecto.Changeset{}}
  def update(usuario_cpf, attrs) do
    with %Pesquisador{} = pesquisador <- one(usuario_cpf),
         {:ok, updated} <-
           pesquisador
           |> Pesquisador.changeset(attrs)
           |> Repo.update() do
      {:ok, updated}
    end
  end

  @spec exists?(String.t()) :: boolean
  def exists?(cpf) do
    User
    |> where([p], p.cpf == ^cpf)
    |> Repo.exists?()
  end

  @spec query :: %Ecto.Query{}
  def query do
    from p in Pesquisador,
      left_join: campus in assoc(p, :campus),
      left_join: pesquisador in assoc(p, :orientador),
      order_by: [desc: p.created_at]
  end

  @spec preload_all(%Ecto.Query{}) :: %Ecto.Query{}
  def preload_all(%Ecto.Query{} = query) do
    query
    |> Ecto.Query.preload([:campus])
  end

  @spec preload_all(%Pesquisador{}) :: %Pesquisador{}
  def preload_all(%Pesquisador{} = pesquisador) do
    pesquisador
    |> Repo.preload([:campus])
  end
end
