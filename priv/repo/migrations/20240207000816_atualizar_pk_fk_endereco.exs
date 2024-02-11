defmodule Pescarte.Database.Repo.Migrations.AtualizarPkFkEndereco do
  use Ecto.Migration

  def change do
    drop_if_exists index(:campus, [:endereco_cep,:acronimo])
    drop_if_exists index(:contato, [:endereco_cep])
    flush()

    execute "ALTER TABLE campus DROP CONSTRAINT campus_endereco_cep_fkey"
    execute "ALTER TABLE contato DROP CONSTRAINT contato_endereco_cep_fkey"
    # rename table(:campus), :endereco_cep, to: :endereco_id
    # rename table(:contato), :endereco_cep, to: :endereco_id
    alter table(:campus) do
      remove :endereco_cep
    end
    alter table(:contato) do
      remove :endereco_cep
    end
    flush()

    # drop_if_exists index(:endereco, [:cep])

    execute "ALTER TABLE endereco DROP CONSTRAINT endereco_pkey"
    flush()

    alter table(:endereco) do
      modify :id, :string, primary_key: true
    end
    create(index(:endereco, [:id]))
    flush()

    alter table(:campus) do
      add :endereco_id,
           references(:endereco, column: :id, type: :string, null: false) #, on_update: :update_all, on_delete: :delete_all),

    end

    create(index(:campus, [:endereco_id]))

    alter table(:contato) do
      add :endereco_id,
           references(:endereco, column: :id, type: :string, null: false) # on_update: :update_all, on_delete: :delete_all),
    end
    create(index(:contato, [:endereco_id]))

  end
end
