defmodule Pescarte.Database.Repo.Migrations.RemoveHashSenhaFromUsuario do
  use Ecto.Migration

  def change do
    alter table(:usuario) do
      remove :hash_senha, :string
    end
  end
end
