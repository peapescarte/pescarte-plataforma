defmodule Fuschia.Repo.Migrations.CreateRelatorio do
  use Ecto.Migration

  def change do
    create table("relatorio", primary_key: false) do
      add :ano, :smallint, null: false, primary_key: true
      add :mes, :smallint, null: false, primary_key: true
      add :tipo_relatorio, :string, null: false
      add :link, :string, null: false

      add :pesquisador_cpf,
          references(
            :pesquisador,
            column: :usuario_cpf,
            type: :citext,
            on_delete: :delete_all
          )
    end

    create unique_index(:relatorio, [:ano, :mes])
    create(index(:relatorio, [:pesquisador_cpf]))
  end
end
