defmodule Pescarte.Database.Repo.Migrations.AtualizarCamposPequisador do
  use Ecto.Migration

  def change do
    alter table(:pesquisador) do
      remove :link_avatar
      modify :minibio, :text, null: true
      add :anotacoes, :text
      modify :data_fim_bolsa, :date, null: true
    end
  end
end
