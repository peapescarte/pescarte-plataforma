defmodule Fuschia.Repo.Migrations.CreateUsuariosAuthTables do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :public_id, :string
      add :cpf, :citext, null: false
      add :first_name, :string, null: false
      add :middle_name, :string
      add :last_name, :string, null: false
      add :birthdate, :date, null: false
      add :role, :string, default: "avulso", null: false
      add :last_seen, :utc_datetime_usec
      add :active?, :boolean, default: true, null: false
      add :password_hash, :string
      add :confirmed_at, :naive_datetime
      add :contact_id, references(:contact, on_replace: :update), null: false

      timestamps()
    end

    create unique_index(:user, [:cpf])
    create unique_index(:user, [:first_name, :middle_name, :last_name, :cpf])

    create table(:user_token) do
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string

      add :user_id, references(:user), null: false

      timestamps(updated_at: false)
    end

    create index(:user_token, [:user_id])
    create unique_index(:user_token, [:context, :token])
  end
end
