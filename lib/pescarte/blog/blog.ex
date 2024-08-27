defmodule Pescarte.Blog.Blog do
  @moduledoc """
  O contexto Blog é responsável por gerenciar as operações relacionadas aos Posts e as Tags.
  """

  alias Pescarte.Blog.Entity.Tag
  alias Pescarte.Database.Repo
  import Ecto.Query

  @spec list_tags() :: {:ok, list(Tag.t())} | {:error, term()}
  def list_tags do
    Repo.replica().all(Tag)
  end

  @spec fetch_tag_by_id(String.t()) :: {:ok, Tag.t()} | {:error, term()}
  def fetch_tag_by_id(id) do
    Pescarte.Database.fetch(Tag, id)
  end

  @spec fetch_tag_by_name(String.t()) :: {:ok, Tag.t()} | {:error, term()}
  def fetch_tag_by_name(nome) do
    Pescarte.Database.fetch_by(Tag, nome: nome)
  end

  @spec create_tag(map()) :: {:ok, Tag.t()} | {:error, Ecto.Changeset.t()}
  def create_tag(attrs) do
    %Tag{}
    |> Tag.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_tag(String.t(), map()) :: {:ok, :updated} | {:error, :not_found}
  def update_tag(id, attrs) do
    query = from(t in Tag, where: t.id == ^id)

    query
    |> Repo.update_all(set: Map.to_list(attrs))
    |> case do
      {0, _} -> {:error, :not_found}
      {_, _} -> {:ok, :updated}
    end
  end

  @spec delete_tag(String.t()) :: {:ok, :deleted} | {:error, :not_found}
  def delete_tag(id) do
    query = from(t in Tag, where: t.id == ^id)

    query
    |> Repo.delete_all()
    |> case do
      {0, _} -> {:error, :not_found}
      {_, _} -> {:ok, :deleted}
    end
  end
end
