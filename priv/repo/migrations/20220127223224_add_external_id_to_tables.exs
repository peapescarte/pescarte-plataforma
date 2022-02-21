defmodule Fuschia.Repo.Migrations.AddExternalIdToTables do
  use Ecto.Migration

  def change do
    for table_name <- public_tables() do
      alter table(table_name) do
        add :id, :string, null: false
      end
    end
  end

  defp public_tables do
    ~w(campus cidade linha_pesquisa midia nucleo pesquisador relatorio user)
  end
end
