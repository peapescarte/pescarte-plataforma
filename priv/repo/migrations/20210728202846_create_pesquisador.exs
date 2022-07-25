defmodule Fuschia.Repo.Migrations.CreatePesquisador do
  use Ecto.Migration

  def change do
    create table(:pesquisador, primary_key: false) do
      add :id, :string, primary_key: true, null: false
      add :tipo_bolsa, :string, default: "pesquisa", null: false
      add :minibiografia, :string, null: false, size: 280
      add :link_lattes, :string, null: false
      add :user_id, references(:user, type: :string), null: false
      add :campus_id, references(:campus, type: :string), null: false
      add :orientador_id, references(:pesquisador, type: :string), null: false

      timestamps()
    end

    create index(:pesquisador, [:user_id])
    create index(:pesquisador, [:campus_id])
    create index(:pesquisador, [:orientador_id])
  end
end
