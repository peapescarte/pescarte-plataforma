defmodule Pescarte.Repo.Migrations.AddMissingFields do
  use Ecto.Migration

  def change do
    alter table(:linha_pesquisa) do
      add :pesquisador_id, references(:pesquisador)
      add :responsavel_lp_id, references(:pesquisador)
    end

    alter table(:pesquisador) do
      add :formacao, :string
      add :data_inicio_bolsa, :date
      add :data_fim_bolsa, :date
      add :data_contratacao, :date
      add :rg, :string
    end

    alter table(:user) do
      add :avatar_link, :string
    end

    alter table(:nucleo_pesquisa) do
      add :letter, :string
    end

    alter table(:cidade) do
      add :contato_id, references(:contato)
    end

    alter table(:contato) do
      remove :address, :string
    end
  end
end
