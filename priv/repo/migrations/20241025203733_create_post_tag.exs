defmodule Pescarte.Database.Repo.Migrations.CreatePostTags do
  use Ecto.Migration

  def change do
    create table(:post_tag) do
      add :tag_id, references(:blog_tag, type: :string), null: false
      add :post_id, references(:blog_posts, type: :string), null: false
      timestamps()
    end
  end
end
