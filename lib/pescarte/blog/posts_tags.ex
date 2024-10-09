defmodule Pescarte.Blog.PostsTags do
  alias Pescarte.Blog.Entity.Tag
  alias Pescarte.Blog.Post
  # alias Pescarte.Database
  # alias Pescarte.Database.Repo
  # alias Pescarte.Database.Types.PublicId
  # alias Pescarte.Identidades.Models.Usuario
  use Pescarte, :model

  schema("posts_tags") do
    belongs_to :post, Post
    belongs_to :tag, Tag
    timestamps()
  end

  def changeset(changeset \\ %PostTag{}, opts) do
  end
end
