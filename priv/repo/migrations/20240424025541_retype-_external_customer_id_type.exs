defmodule :"Elixir.Pescarte.Database.Repo.Migrations.Retype-ExternalCustomerIdType" do
  use Ecto.Migration

  def change do
    alter table(:usuario) do
      modify :external_customer_id, :text, from: :binary_id
    end
  end
end
