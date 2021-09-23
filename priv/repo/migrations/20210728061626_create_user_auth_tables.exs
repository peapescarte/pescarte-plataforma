defmodule Fuschia.Repo.Migrations.CreateUsuariosAuthTables do
  use Ecto.Migration

  def change do
    create table(:user, primary_key: false) do
      add(:cpf, :citext, primary_key: true, null: false)
      add(:nome_completo, :string, null: false)
      add(:data_nascimento, :date, null: false)
      add(:perfil, :string, default: "avulso", null: false)
      add(:last_seen, :utc_datetime_usec)
      add(:ativo, :boolean, default: true, null: false)
      add(:password_hash, :string)
      add(:confirmed, :boolean, default: false)

      add(:contato_id, references(:contato, on_replace: :update), null: false)

      timestamps()
    end

    create(unique_index(:user, [:cpf]))
    create(unique_index(:user, [:nome_completo]))

    create table(:user_token) do
      add(:token, :binary, null: false)
      add(:context, :string, null: false)
      add(:sent_to, :string)

      add(:user_cpf, references(:user, column: :cpf, type: :citext, on_delete: :delete_all),
        null: false
      )

      timestamps(updated_at: false)
    end

    create(index(:user_token, [:user_cpf]))
    create(unique_index(:user_token, [:context, :token]))
  end
end
