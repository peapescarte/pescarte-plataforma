defmodule Pescarte.Database.Repo.Migrations.CreatePostTags do
  use Ecto.Migration

  def change do
    create table(:posts_tags_relation, primary_key: :false) do
      add :id, :string, primary_key: :true
      add :tag_id, references(:blog_tag, type: :string), null: false
      add :post_id, references(:blog_posts, type: :string), null: false
      timestamps()
    end
  end
end
