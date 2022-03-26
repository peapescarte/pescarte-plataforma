defmodule Fuschia.ModuloPesquisa.Queries.RelatoriosTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Database
  alias Fuschia.ModuloPesquisa.Models.RelatorioModel, as: Relatorio
  alias Fuschia.ModuloPesquisa.Queries.RelatorioQueries, as: Relatorios

  @moduletag :unit

  describe "list/0" do
    test "return all relatorios in database" do
      insert(:relatorio)

      relatorio = Database.one(Relatorios.query())

      assert [relatorio] == Database.list(Relatorios.query())
    end
  end

  describe "list_by_pesquisador/1" do
    test "return all relatorio in database" do
      insert(:relatorio)

      relatorio = Database.one(Relatorios.query())

      assert [relatorio] ==
               relatorio.pesquisador_cpf |> Relatorios.query_by_pesquisador() |> Database.list()
    end
  end

  describe "one/1" do
    test "when numero is valid, returns a relatorio" do
      insert(:relatorio)

      relatorio = Database.one(Relatorios.query())

      assert relatorio ==
               Database.get_by(Relatorios.query(), ano: relatorio.ano, mes: relatorio.mes)
    end

    test "when id is invalid, returns nil" do
      assert Relatorios.query() |> Database.get_by(ano: 0, mes: 0) |> is_nil()
    end
  end

  describe "create/1" do
    @invalid_attrs %{
      ano: nil,
      mes: nil,
      link: nil,
      tipo: nil,
      pesquisador_cpf: nil
    }

    test "when all params are valid, creates a relatorio" do
      valid_attrs = params_for(:relatorio)

      assert {:ok, %Relatorio{}} = Database.create(Relatorio, valid_attrs)
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Database.create(Relatorio, @invalid_attrs)
    end
  end

  describe "update/1" do
    @update_attrs %{
      ano: Date.utc_today().year - 2,
      mes: Integer.mod(Date.utc_today().month + 1, 12),
      link: "https://example.com",
      tipo: "trimestral"
    }

    @invalid_attrs %{
      ano: nil,
      mes: nil,
      link: nil,
      tipo: nil,
      pesquisador_cpf: nil
    }

    test "when all params are valid, updates a midia" do
      attrs = params_for(:relatorio)

      assert {:ok, relatorio} = Database.create(Relatorio, attrs)

      assert {:ok, updated_relatorio} = Database.update_struct(relatorio, @update_attrs)

      assert updated_relatorio.ano == @update_attrs.ano
      assert updated_relatorio.mes == @update_attrs.mes
      assert updated_relatorio.link == @update_attrs.link
      assert updated_relatorio.tipo == @update_attrs.tipo
    end

    test "when params are invalid, returns an error changeset" do
      attrs = params_for(:relatorio)

      assert {:ok, relatorio} = Database.create(Relatorio, attrs)

      assert {:error, %Ecto.Changeset{}} = Database.update_struct(relatorio, @invalid_attrs)
    end
  end
end
