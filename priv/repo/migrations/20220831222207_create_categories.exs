defmodule Pescarte.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table("categorias") do
      add :name, :string, null: false
      add :public_id, :string

      timestamps()
    end

    create index("categorias", [:name])
  end
end
