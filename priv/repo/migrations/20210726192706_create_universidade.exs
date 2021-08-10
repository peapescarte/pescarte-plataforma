defmodule Fuschia.Repo.Migrations.CreateUniversidade do
  use Ecto.Migration

  def change do
    create table(:universidade, primary_key: false) do
      add :nome, :string, null: false

      add :cidade_municipio,
          references(:cidade, column: :municipio, type: :string, on_delete: :delete_all),
          null: false

      timestamps()
    end

    create unique_index(:universidade, [:nome])
    create unique_index(:universidade, [:cidade_municipio])
  end
end
