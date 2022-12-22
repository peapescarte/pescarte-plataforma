defmodule Pescarte.Repo.Migrations.AddstatusQuarterlyReport do
  use Ecto.Migration

  def change do
    alter table(:quarterly_report) do
      add :status, :string
    end
  end
end
