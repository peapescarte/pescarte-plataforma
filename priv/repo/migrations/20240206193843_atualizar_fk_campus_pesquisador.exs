defmodule Pescarte.Database.Repo.Migrations.AtualizarFkCampusPesquisador do
  use Ecto.Migration

  def change do

    drop_if_exists index(:campus, [:acronimo])
    drop_if_exists index(:pesquisador, [:campus_acronimo])
    flush()

    alter table(:pesquisador) do
      modify :campus_acronimo, references(:campus, on_delete: :delete_all)
    end
    flush()

    alter table(:campus) do
      remove :acronimo
    end
    flush()

    alter table(:campus) do
      modify :id_publico, :string, primary_key: true
      add :acronimo, :string, size: 20, primary_key: false, null: false
    end
    create unique_index(:campus, [:acronimo, :nome])
    flush()

    alter table(:pesquisador) do
      remove :campus_acronimo
      add :campus_id, references(:campus, column: :id_publico, type: :string), null: false
    end
    create(index(:pesquisador, [:campus_id]))


  end
end
