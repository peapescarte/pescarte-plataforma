defmodule Pescarte.Database.Repo.Migrations.RenameBlogPostRelation do
  use Ecto.Migration

  def change do
    drop_if_exists index(:blog_posts, [:user_id])
    rename table(:blog_posts), :user_id, to: :usuario_id
    create index(:blog_posts, [:usuario_id])
  end
end
