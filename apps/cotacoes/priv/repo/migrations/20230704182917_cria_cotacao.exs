defmodule Database.EscritaRepo.Migrations.CriaCotacao do
  use Ecto.Migration

  def change do
    create table(:cotacao, primary_key: false) do
      add :data, :date, primary_key: true, null: false
      add :link, :string
      add :fonte_nome, references(:fonte, column: :nome, type: :string), null: false
    end

    create index(:cotacao, [:fonte_nome])
    create unique_index(:cotacao, [:data])
  end
end
