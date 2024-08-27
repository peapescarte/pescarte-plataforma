defmodule Pescarte.Blog.Entity.Tag do
  use Pescarte, :model

  alias Pescarte.Database.Types.PublicId

  @type t :: %Tag{nome: binary, id: binary}

  @required_fields ~w(nome)a

  @primary_key {:id, PublicId, autogenerate: true}
  schema "blog_tag" do
    field :nome, :string

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

  @spec create_tag(map()) :: {:ok, Tag.t()} | {:error, changeset}
  def create_tag(attrs) do
    %Tag{}
    |> changeset(attrs)
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
