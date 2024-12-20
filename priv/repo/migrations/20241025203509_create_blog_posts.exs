defmodule Pescarte.Database.Repo.Migrations.CreatePost do
  alias Pescarte.Database.Types.PublicId
  use Ecto.Migration

  def change do
    create table(:blog_posts, primary_key: :false) do
      add :id, :string, primary_key: true
      add :usuario_id, references(:usuario, type: :string)
      add :titulo, :string
      add :conteudo, :binary
      add :link_imagem_capa, :string
      add :published_at, :naive_datetime

      timestamps()
  end

  create unique_index(:blog_posts, :titulo)
end
end
