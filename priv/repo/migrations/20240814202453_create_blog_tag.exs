defmodule Pescarte.Database.Repo.Migrations.CreateBlogTag do
  use Ecto.Migration

  def change do
    create table(:blog_tag, primary_key: false) do
      add :id, :string, primary_key: true
      add :nome, :string, null: false

      timestamps()
    end

    create unique_index(:blog_tag, [:nome])
  end
end
