defmodule Database.EscritaRepo.Migrations.CriaPescado do
  use Ecto.Migration

  def change do
    create table(:pescado, primary_key: false) do
      add :codigo, :string, primary_key: true, null: false
      add :descricao, :string
      add :embalagem, :string
    end

    create unique_index(:pescado, [:codigo])
  end
end
