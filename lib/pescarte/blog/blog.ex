defmodule Pescarte.Blog do
  @moduledoc """
  O contexto Blog é responsável por gerenciar as operações relacionadas a postagens e tags.
  """
  import Ecto.Query
  alias Pescarte.Database.Repo
  alias Pescarte.Blog.{Post}

  @type filters :: %{
    optional(:title) => String.t(),
    optional(:start_date) => NaiveDateTime.t(),
    optional(:end_date) => NaiveDateTime.t(),
    optional(:tags) => list(Tag.t())
  }

  @spec list_posts_with_filter(filters()) :: {:ok, list(Post.t())} | {:error, term()}
  def list_posts_with_filter(filters \\ %{}) do
    Post
    |> apply_post_search_filter(filters)
    |> apply_post_date_filter(filters)
    |> Repo.replica().all()
  end

  defp apply_post_search_filter(query, %{title: search_term}) do
    from(p in query, where: ilike(p.titulo, ^"%#{search_term}%"))
  end

  defp apply_post_date_filter(query, %{start_date: start_date, end_date: end_date}) do
    from p in query, where: p.inserted_at >= ^start_date and p.inserted_at <= ^end_date
  end
end
