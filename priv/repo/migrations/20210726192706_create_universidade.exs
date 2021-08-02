defmodule Fuschia.Repo.Migrations.CreateUniversidade do
  use Ecto.Migration

  def change do
    create table(:universidade) do
      add :nome_cidade,
          references(:cidade, column: :municipio, type: :string, on_delete: :delete_all),
          null: false

      add :nome, :string, null: false

      timestamps()
    end

    create unique_index(:universidade, [:nome, :nome_cidade], name: :universidade_cidade_index)
  end
end
