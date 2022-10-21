defmodule Backend.Repo.Migrations.CreateResearcher do
  use Ecto.Migration

  def change do
    create table(:researcher) do
      add :public_id, :string
      add :bursary, :string, default: "pesquisa", null: false
      add :minibio, :string, null: false, size: 280
      add :link_lattes, :string, null: false
      add :advisor_id, references(:researcher)
      add :user_id, references(:user), null: false
      add :campus_id, references(:campus), null: false

      timestamps()
    end

    create index(:researcher, [:user_id])
    create index(:researcher, [:campus_id])
    create index(:researcher, [:advisor_id])
  end
end
