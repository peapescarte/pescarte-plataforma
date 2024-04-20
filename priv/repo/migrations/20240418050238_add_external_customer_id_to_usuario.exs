defmodule Pescarte.Database.Repo.Migrations.AddExternalCustomerIdToUsuario do
  use Ecto.Migration

  def change do
    alter table(:usuario) do
      add :external_customer_id, :binary_id
    end

    drop_if_exists table(:token_usuario)
  end
end
