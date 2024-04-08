defmodule Pescarte.Database.Repo.Migrations.CreatePeixesHabitats do
  use Ecto.Migration

  def change do
    create table(:peixes_habitats) do
      add :peixe_id, references(:peixe, type: :string), null: false
      add :habitat_id, references(:habitat, type: :string), null: false
    end

    create index(:peixes_habitats, [:peixe_id])
    create index(:peixes_habitats, [:habitat_id])
  end
end
