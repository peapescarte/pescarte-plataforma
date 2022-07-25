defmodule Fuschia.Repo.Migrations.InstallCarbonite do
  use Ecto.Migration

  @mode Application.compile_env!(:fuschia, :carbonite_mode)

  def up do
    Carbonite.Migrations.up(1)
    Carbonite.Migrations.up(2)

    for table <- audit_tables() do
      Carbonite.Migrations.create_trigger(table)
      Carbonite.Migrations.put_trigger_config(table, :mode, @mode)
    end
  end

  def down do
    for table <- audit_tables() do
      Carbonite.Migrations.drop_trigger(table)
    end

    Carbonite.Migrations.down(2)
    Carbonite.Migrations.down(1)
  end

  defp audit_tables do
    ~w(campus cidade core linha_pesquisa midia pesquisador relatorio user)a
  end
end
