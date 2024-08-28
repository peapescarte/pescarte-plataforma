defmodule Pescarte.Blog.Post do
  @moduledoc """
  Módulo que define o schema e o changeset para os posts.
  """
  alias Pescarte.Database.Types.PublicId
  alias Pescarte.Identidades.Models.Usuario
  alias Pescarte.Blog.BlogPosts.Post
  alias Pescarte.Database
  alias Pescarte.Database.Repo
  use Pescarte, :model

  @type t :: %Post{
          id: String.t(),
          titulo: String.t(),
          conteudo: String.t(),
          link_imagem_capa: String.t(),
          published_at: NaiveDateTime.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t(),
          usuario: Usuario.t(),
          usuario_id: String.t()
        }

  @required_params [:titulo, :conteudo, :link_imagem_capa, :published_at]

  @primary_key {:id, PublicId, autogenerate: true}
  schema "posts" do
    field :titulo, :string
    field :conteudo, :binary
    field :link_imagem_capa, :string
    field :published_at, :naive_datetime

    belongs_to :usuario, Usuario

    # comentado enquanto o PR das tags não é aprovado
    # has_many :tags, Tag, through: [:post_tags, :tag]

    timestamps()
  end

  def changeset(post \\ %Post{}, params) do
    post
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> unique_constraint(:titulo)
  end


  @spec get_posts :: list(Post.t()) | Ecto.QueryError
  def get_posts do
    Repo.Replica.all(Post)
  end

  @spec get_post(String.t()) :: {:ok, Post.t()} | {:error, :not_found}
  def get_post(id) do
    Database.fetch(Post, id)
  end

  @spec create_post(Post.t()) :: {:ok, Post.t()} | {:error, Ecto.Changeset.t()}
  def create_post(params) do
    %Post{}
    |> Post.changeset(params)
    |> Repo.insert()
  end

  @spec delete_post(String.t()) :: {:ok, Post.t()} | {:error, Ecto.Changeset.t()}
  def delete_post(id) do
    case Repo.get(Post, id) do
      nil -> {:error, :not_found}
      post -> Repo.delete(post)
    end
  end

  @spec update_post(String.t(), Post.t()) :: {:ok, Post.t()} | {:error, Ecto.Changeset.t()}
  def update_post(id, params) do
    case Repo.get(Post, id) do
      nil ->
        {:error, :not_found}

      post ->
        post
        |> Post.changeset(params)
        |> Repo.update()
    end
  end
end
