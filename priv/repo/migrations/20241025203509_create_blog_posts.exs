defmodule Pescarte.Database.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:blog_posts, primary_key: false) do
      add :id, :string, primary_key: true
      add :titulo, :string
      add :conteudo, :binary
      add :link_imagem_capa, :string
      add :published_at, :naive_datetime
      add :user_id, references(:usuario, type: :string)

      timestamps()
    end

    create unique_index(:blog_posts, :titulo)
    create index(:blog_posts, :user_id)
  end
end
