defmodule Fuschia.Repo.Migrations.AddAuthLog do
  use Ecto.Migration

  def change do
    create table(:auth_log) do
      add :ip, :string, null: false
      add :user_agent, :string, null: false
      add :user_id, references(:user, type: :string), null: false

      timestamps(updated_at: false)
    end

    create index(:auth_log, [:ip])
    create index(:auth_log, [:user_agent])
    create index(:auth_log, [:user_id])
  end
end
