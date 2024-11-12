defmodule Pescarte.Blog.Entity.Tag do
  @moduledoc """
  A entidade `Tag` fornece um CRUD básico para a mesma e é responsável por categorizar os posts do contexto Blog, para filtragem e pesquisa.
  """

  use Pescarte, :model

  alias Pescarte.Blog.Post
  alias Pescarte.Database.Types.PublicId

  @type t :: %Tag{nome: binary, id: binary}

  @required_fields ~w(nome)a

  @primary_key {:id, PublicId, autogenerate: true}
  schema "blog_tag" do
    field :nome, :string
    many_to_many :blog_posts, Post, join_through: "posts_tags"

    timestamps()
  end

  @spec changeset(Tag.t(), map) :: changeset
  def changeset(%Tag{} = tag, attrs) do
    tag
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:nome)
  end

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

  @spec to_changesets(list(Map.t()), list()) :: {:ok, list(Tag.t())}
  def to_changesets(list, acc\\[])
  def to_changesets([], acc), do: {:ok, acc}
  def to_changesets([tag | rest], acc), do: to_changesets(rest,[changeset(%Tag{}, tag) | acc])


  @spec create_tag(map()) :: {:ok, Tag.t()} | {:error, changeset}
  def create_tag(attrs) do
    %Tag{}
    |> changeset(attrs)
    |> Repo.insert()
  end

  @spec update_tag(String.t(), map()) :: {:ok, Tag.t()} | {:error, :not_found}
  def update_tag(id, attrs) do
    query = from(t in Tag, where: t.id == ^id, select: t)

    attrs_with_updated_date = Map.put(attrs, :updated_at, NaiveDateTime.utc_now())

    query
    |> Repo.update_all(set: Map.to_list(attrs_with_updated_date))
    |> case do
      {1, [updated_tag]} -> {:ok, updated_tag}
      {_, _} -> {:error, :not_found}
    end
  end

  @spec delete_tag(String.t()) :: :ok | {:error, :not_found}
  def delete_tag(id) do
    query = from(t in Tag, where: t.id == ^id)

    query
    |> Repo.delete_all()
    |> case do
      {1, _} -> :ok
      {_, _} -> {:error, :not_found}
    end
  end
end
