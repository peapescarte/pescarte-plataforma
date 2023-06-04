defmodule Pescarte.Repo.Migrations.CriaUsuario do
  use Ecto.Migration

  def change do
    create table(:usuario) do
      add :id_publico, :string, null: false
      add :cpf, :citext, null: false
      add :primeiro_nome, :string, null: false
      add :sobrenome, :string, null: false
      add :data_nascimento, :date, null: false
      add :tipo, :string, default: "avulso", null: false
      add :hash_senha, :string
      add :confirmado_em, :naive_datetime
      add :ativo?, :boolean

      add :contato_id, references(:contato, on_replace: :update), null: false

      timestamps()
    end

    create unique_index(:usuario, [:cpf])
    create unique_index(:usuario, [:primeiro_nome, :sobrenome, :cpf])

    create table(:user_token) do
      add :token, :binary, null: false
      add :contexto, :string, null: false
      add :enviado_para, :string

      add :usuario_id, references(:usuario), null: false

      timestamps(updated_at: false)
    end

    create index(:user_token, [:usuario_id])
    create unique_index(:user_token, [:contexto, :token])
  end
end
