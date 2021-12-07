defmodule Fuschia.Repo.Migrations.CreateMidia do
  use Ecto.Migration

  def change do
    create table("midia", primary_key: false) do
      add :tipo, :string, null: false
      add :tags, {:array, :string}, null: false
      add :link, :string, null: false, primary_key: true

      add :pesquisador_cpf,
          references(
            :pesquisador,
            column: :usuario_cpf,
            type: :citext,
            on_delete: :delete_all
          )
    end

    create(index(:midia, [:pesquisador_cpf]))
  end
end
