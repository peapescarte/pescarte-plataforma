defmodule Fuschia.Repo.Migrations.AddRawContentToRelatorio do
  use Ecto.Migration

  def change do
    alter table(:relatorio) do
      add :raw_content, :string, null: false
    end

    create index(:relatorio, [:raw_content])
  end
end
