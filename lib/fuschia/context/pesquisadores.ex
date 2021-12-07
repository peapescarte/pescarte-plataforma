defmodule Fuschia.Context.Pesquisadores do
  @moduledoc """
  Public Fuschia Pesquisador API
  """

  import Ecto.Query

  alias Fuschia.Context.Users
  alias Fuschia.Entities.{Pesquisador, User}
  alias Fuschia.{Parser, Repo}

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
    |> Repo.all()
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
    attrs
    |> Parser.stringfy_map()
    |> Map.put_new("usuario", nil)
    |> case do
      %{"usuario" => nil} ->
        with %Pesquisador{} = pesquisador <- one(usuario_cpf),
             {:ok, updated} <-
               pesquisador
               |> Pesquisador.changeset(attrs)
               |> Repo.update() do
          {:ok, preload_all(updated)}
        end

      %{"usuario" => usuario_attrs} ->
        with %User{} = _user <- Users.one(usuario_cpf),
             %Ecto.Changeset{valid?: true} = usuario_changeset <-
               User.changeset(%User{}, usuario_attrs),
             {:ok, pesquisador} <-
               attrs
               |> Map.replace("usuario", usuario_changeset)
               |> then(&Pesquisador.update_changeset(%Pesquisador{}, &1))
               |> Repo.insert(on_conflict: :nothing) do
          {:ok, preload_all(pesquisador)}
        end
    end
  end

  @spec exists?(String.t()) :: boolean
  def exists?(usuario_cpf) do
    Pesquisador
    |> where([p], p.usuario_cpf == ^usuario_cpf)
    |> Repo.exists?()
  end

  @spec query :: %Ecto.Query{}
  def query do
    from p in Pesquisador,
      left_join: campus in assoc(p, :campus),
      left_join: orientador in assoc(p, :orientador),
      order_by: [desc: p.created_at]
  end

  @spec preload_all(%Ecto.Query{}) :: %Ecto.Query{}
  def preload_all(%Ecto.Query{} = query) do
    Ecto.Query.preload(
      query,
      orientador: [usuario: :contato],
      orientandos: [usuario: :contato],
      usuario: :contato,
      campus: :cidade
    )
  end

  @spec preload_all(%Pesquisador{}) :: %Pesquisador{}
  def preload_all(%Pesquisador{} = pesquisador) do
    Repo.preload(
      pesquisador,
      orientador: [usuario: :contato],
      orientandos: [usuario: :contato],
      usuario: :contato,
      campus: :cidade
    )
  end
end
