defmodule Pescarte.Database.Repo.Migrations.CreateUsuario do
  use Ecto.Migration

  def change do
    create table(:usuario, primary_key: false) do
      add :id, :string, primary_key: true
      add :cpf, :string, null: false
      add :rg, :string, null: false
      add :hash_senha, :string, null: false
      add :confirmado_em, :utc_datetime
      add :data_nascimento, :date
      add :papel, :string, null: false
      add :primeiro_nome, :string, null: false
      add :sobrenome, :string
      add :link_avatar, :string
      add :ativo?, :boolean, default: false
      add :contato_id, references(:contato, type: :string), null: false

      timestamps()
    end

    create unique_index(:usuario, [:cpf])

    create table(:token_usuario) do
      add :token, :binary
      add :contexto, :string
      add :enviado_para, :string
      add :usuario_id, references(:usuario, type: :string), null: false

      timestamps(updated_at: false)
    end

    create index(:token_usuario, [:usuario_id])
  end
end
