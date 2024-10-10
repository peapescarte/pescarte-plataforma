defmodule Pescarte.Database.Repo.Migrations.CreatePost do
  use Ecto.Migration

  def change do
    create table(:posts, primary_key: false) do
      add :user_id, references(:usuario, type: :string), null: false
      add :titulo, :string
      add :conteudo, :binary
      add :link_imagem_capa, :string
      add :published_at, :naive_datetime

      timestamps()
  end

  create unique_index(:posts, :titulo)
  create index(:posts, :user_id)
end
end
