defmodule Pescarte.Database.Repo.Migrations.RenamePostTagTable do
  use Ecto.Migration

  def change do
    rename table(:posts_tag), to: table(:posts_tags)
  end
end
