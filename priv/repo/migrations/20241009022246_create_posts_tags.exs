defmodule Pescarte.Database.Repo.Migrations.CreatePostTags do
  alias Pescarte.Blog.Entity.Tag
  alias Pescarte.Blog.Post
  use Ecto.Migration

  def change do
    create table(:posts_tags) do
      add :post_id, references(Post)
      add :tag_id, references(Tag)
      timestamps()
    end
  end
end
