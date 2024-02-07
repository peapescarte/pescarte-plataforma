defmodule Pescarte.Database.Repo.Migrations.AtualizarPkFkContato do
  use Ecto.Migration

  def change do
    drop_if_exists index(:usuario, [:contato_email])
    execute "ALTER TABLE usuario DROP CONSTRAINT usuario_contato_email_fkey"
    flush()

    alter table(:usuario) do
        remove :contato_email
      end
    flush()

    execute "ALTER TABLE contato DROP CONSTRAINT contato_pkey"
    flush()

    alter table(:contato) do
      modify :id_publico, :string, primary_key: true
    end
    create(index(:contato, [:id_publico]))
    flush()

    alter table(:usuario) do
      add :contato_id,
          references(:contato, column: :id_publico, type: :string, null: false)
    end
    create(index(:usuario, [:contato_id]))

  end
end
