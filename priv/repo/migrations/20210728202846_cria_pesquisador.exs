defmodule Pescarte.Repo.Migrations.CreatePesquisador do
  use Ecto.Migration

  def change do
    create table(:pesquisador) do
      add :id_publico, :string, null: false

      add :rg, :citext, null: false
      add :bolsa, :string, default: "pesquisa", null: false
      add :minibio, :string, null: false, size: 280
      add :link_lattes, :string, null: false
      add :link_linkedin, :string, null: false
      add :link_avatar, :string
      add :link_banner_perfil, :string
      add :formacao, :string
      add :data_inicio_bolsa, :date
      add :data_fim_bolsa, :date
      add :data_contratacao, :date
      add :data_termino, :date

      add :orientador_id, references(:pesquisador), null: true
      add :usuario_id, references(:usuario), null: false
      add :campus_id, references(:campus), null: false

      timestamps()
    end

    create index(:pesquisador, [:usuario_id])
    create index(:pesquisador, [:campus_id])
    create index(:pesquisador, [:orientador_id])
  end
end
