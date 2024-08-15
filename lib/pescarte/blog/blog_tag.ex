defmodule Pescarte.Blog.BlogTag do
  @moduledoc """
  O contexto BlogTag é responsável por gerenciar as operações relacionadas a TAG.
  """

  alias Pescarte.Blog.Models.Tag
  alias Pescarte.Database.Repo

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

  @spec update_tag(String.t(), map()) ::
          {:ok, Tag.t()} | {:error, :not_found | Ecto.Changeset.t()}
  def update_tag(id, attrs) do
    case Repo.get(Tag, id) do
      nil ->
        {:error, :not_found}

      tag ->
        tag
        |> Tag.changeset(attrs)
        |> Repo.update()
    end
  end

  @spec delete_tag_by_id(String.t()) :: {:ok, Tag.t()} | {:error, :not_found}
  def delete_tag_by_id(id) do
    case Repo.get(Tag, id) do
      nil -> {:error, :not_found}
      tag -> Repo.delete(tag)
    end
  end
end
