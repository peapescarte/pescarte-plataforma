defmodule Pescarte.Repo.Migrations.CreatePesquisador do
  use Ecto.Migration

  def change do
    create table(:pesquisador) do
      add :public_id, :string
      add :bolsa, :string, default: "pesquisa", null: false
      add :minibio, :string, null: false, size: 280
      add :link_lattes, :string, null: false
      add :orientador_id, references(:pesquisador)
      add :user_id, references(:user), null: false
      add :campus_id, references(:campus), null: false

      timestamps()
    end

    create index(:pesquisador, [:user_id])
    create index(:pesquisador, [:campus_id])
    create index(:pesquisador, [:orientador_id])
  end
end
