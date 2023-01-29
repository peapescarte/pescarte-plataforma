defmodule Pescarte.Repo.Migrations.AddUserProfileFields do
  use Ecto.Migration

  def change do
    alter table(:pesquisador) do
      add :avatar, :string
      add :link_linkedin, :string
      add :profile_banner, :string
    end
  end
end
