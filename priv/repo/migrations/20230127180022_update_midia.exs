defmodule Pescarte.Repo.Migrations.UpdateMidia do
  use Ecto.Migration

  def change do
    alter table("midia") do
      add :filename, :string, null: false
      add :filedate, :date, null: false
      add :sensible?, :boolean, null: false
      add :observation, :text
      add :alt_text, :string
    end
  end
end
