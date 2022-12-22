defmodule Pescarte.Repo.Migrations.AddstatusMonthlyReport do
  use Ecto.Migration

  def change do
    alter table(:monthly_report) do
      add :status, :string
    end
  end
end
