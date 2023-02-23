defmodule Pescarte.Repo.Migrations.ModifyTagLabelIndex do
  use Ecto.Migration

  def change do
    drop index(:tags, [:label])
    create unique_index(:tags, [:label])
  end
end
