defmodule Fuschia.Repo.Migrations.CreateRelatorio do
  use Ecto.Migration

  def change do
    create table("relatorio", primary_key: false) do
      add :ano, :string, null: false, primary_key: true
      add :mes, :string, null: false
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

    create(index(:relatorio, [:pesquisador_cpf]))
  end
end
