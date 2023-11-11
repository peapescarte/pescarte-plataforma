defmodule Pescarte.ModuloPesquisa.Repo.Migrations.UpdateMidia do
  use Ecto.Migration

  def change do
    alter table(:midia) do
      add :nome_arquivo, :string, null: false
      add :data_arquivo, :date, null: false
      add :restrito?, :boolean, null: false
      add :observacao, :text
      add :texto_alternativo, :string
    end
  end
end
