defmodule Pescarte.Blog.Posts do
  alias Pescarte.Blog.BlogPosts.Post
  alias Pescarte.Database
  alias Pescarte.Database.Repo

  @doc """
  Módulo criado para realizar o CRUD na tabela de posts referentes as notícias.
  """
  @spec get_posts() :: list(Post.t()) | Ecto.QueryError
  def get_posts() do
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
