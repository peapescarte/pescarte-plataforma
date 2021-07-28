defmodule Fuschia.Repo.Migrations.AddAuthLog do
  use Ecto.Migration

  def change do
    create table(:auth_log) do
      timestamps(updated_at: false)

      add :ip, :string, null: false
      add :user_agent, :string, null: false
      add :user_id, references(:user), null: false
    end

    create index(:auth_log, [:ip])
    create index(:auth_log, [:user_agent])
    create index(:auth_log, [:user_id])
  end
end
