defmodule Fuschia.Repo.Migrations.CreatePesquisador do
  use Ecto.Migration

  def change do
    execute &execute_up/0, &execute_down/0

    create table(:pesquisador, primary_key: false) do
      add :tipo_bolsa, :tipos_bolsa, default: "pesquisa", null: false
      add :minibiografia, :string, null: false, size: 280
      add :link_lattes, :string, null: false

      add :usuario_cpf,
          references(:user, column: :cpf, type: :citext, on_delete: :delete_all),
          primary_key: true

      add :orientador_cpf,
          references(:pesquisador, column: :usuario_cpf, type: :citext, on_delete: :delete_all)

      add :campus_id,
          references(:campus, on_delete: :nothing),
          null: false

      timestamps()
    end

    create index(:pesquisador, [:orientador_cpf])
  end

  defp execute_up,
    do:
      repo().query!(
        "CREATE TYPE tipos_bolsa AS ENUM ('pesquisa', 'ic')",
        [],
        log: :info
      )

  defp execute_down, do: repo().query!("DROP TYPE tipos_bolsa", [], log: :info)
end
