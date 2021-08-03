defmodule Fuschia.Repo.Migrations.CreatePesquisador do
  use Ecto.Migration

  def change do
    create table(:pesquisador, primary_key: false) do
      add :tipo_bolsa, :string, null: false
      add :minibibliografia, :string, null: false, size: 280
      add :link_lattes, :string, null: false

      add :cpf_usuario,
          references(:user, column: :cpf, type: :citext, on_delete: :delete_all),
          primary_key: true

      add :cod_orientador,
          references(:pesquisador, column: :cpf_usuario, type: :citext, on_delete: :delete_all)

      add :id_universidade,
          references(:universidade, on_delete: :nothing),
          null: false

      timestamps()
    end

    create index(:pesquisador, [:cod_orientador])
  end
end
