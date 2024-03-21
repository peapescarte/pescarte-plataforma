defmodule Pescarte.Database.Repo.Migrations.AddAvatarUsuario do
  use Ecto.Migration

  def change do
    alter table(:usuario) do
      add :link_avatar, :string
    end
  end
end
