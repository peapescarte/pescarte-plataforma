defmodule Fuschia.Repo.Migrations.CreatePesquisador do
  use Ecto.Migration

  def change do
    create table(:pesquisador, primary_key: false) do
      add(:tipo_bolsa, :string, default: "pesquisa", null: false)
      add(:minibiografia, :string, null: false, size: 280)
      add(:link_lattes, :string, null: false)

      add(
        :usuario_cpf,
        references(:user, column: :cpf, type: :citext, on_delete: :delete_all),
        primary_key: true
      )

      add(
        :orientador_cpf,
        references(
          :pesquisador,
          column: :usuario_cpf,
          type: :citext,
          on_delete: :delete_all
        )
      )

      add(
        :campus_sigla,
        references(:campus, on_delete: :nothing, type: :string, column: :sigla),
        null: false
      )

      timestamps()
    end

    create(index(:pesquisador, [:orientador_cpf]))
  end
end
