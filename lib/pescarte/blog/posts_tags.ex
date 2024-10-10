defmodule Pescarte.Blog.PostsTags do
  @moduledoc """
  Módulo reponsável pelo relacionamento entre posts e tags. Nesse arquivo é feito o schema que permite
  esse relacionamento NxN e também o
  """
  alias Pescarte.Blog.Entity.Tag
  alias Pescarte.Blog.Post
  alias Pescarte.Database.Types.PublicId
  use Ecto.Schema

  @primary_key {:id, PublicId, autogenerate: true}
  schema "posts_tags" do
    belongs_to :post, Post
    belongs_to :tag, Tag
    timestamps()
  end


end
