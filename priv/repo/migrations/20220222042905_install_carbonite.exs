defmodule Fuschia.Repo.Migrations.InstallCarbonite do
  use Ecto.Migration

  @mode Application.compile_env!(:fuschia, :carbonite_mode)

  def up do
    Carbonite.Migrations.up(1)
    Carbonite.Migrations.up(2)

    for %{name: table, pk: primary_keys} <- audit_tables() do
      Carbonite.Migrations.create_trigger(table)
      Carbonite.Migrations.put_trigger_config(table, :primary_key_columns, primary_keys)
      Carbonite.Migrations.put_trigger_config(table, :mode, @mode)
    end
  end

  def down do
    for %{name: table} <- audit_tables() do
      Carbonite.Migrations.drop_trigger(table)
    end

    Carbonite.Migrations.down(2)
    Carbonite.Migrations.down(1)
  end

  defp audit_tables do
    [
      %{name: :campus, pk: ["nome"]},
      %{name: :cidade, pk: ["municipio"]},
      %{name: :linha_pesquisa, pk: ["numero"]},
      %{name: :midia, pk: ["link"]},
      %{name: :nucleo, pk: ["nome"]},
      %{name: :pesquisador, pk: ["usuario_cpf"]},
      %{name: :relatorio, pk: ["ano", "mes"]},
      %{name: :user, pk: ["cpf"]}
    ]
  end
end
