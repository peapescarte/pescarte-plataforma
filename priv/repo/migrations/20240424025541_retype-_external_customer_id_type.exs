defmodule Elixir.Pescarte.Database.Repo.Migrations.RetypeExternalCustomerIdType do
  use Ecto.Migration

  # ESSA MIGRATION É IRREVERSÍVEL

  def change do
    alter table(:usuario) do
      modify :external_customer_id, :text, from: :binary_id
    end
  end
end
