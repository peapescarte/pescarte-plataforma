defmodule Fuschia.ModuloPesquisa do
  @moduledoc """
  Módulo com funções públicas que realizam ações
  do contexto.
  """

  alias Fuschia.Database

  alias Fuschia.ModuloPesquisa.Models.Campus
  alias Fuschia.ModuloPesquisa.Models.Cidade
  alias Fuschia.ModuloPesquisa.Models.Core
  alias Fuschia.ModuloPesquisa.Models.LinhaPesquisa
  alias Fuschia.ModuloPesquisa.Models.Midia
  alias Fuschia.ModuloPesquisa.Models.Pesquisador
  alias Fuschia.ModuloPesquisa.Models.Relatorio
  alias Fuschia.ModuloPesquisa.Queries

  # ---------------------------#
  # Database
  # ---------------------------#

  def create_campus(attrs) do
    Database.create(Campus, attrs)
  end

  def list_campus do
    Database.list(Queries.Campus.query())
  end

  def list_campus_by_municipio(municipio) do
    municipio
    |> Queries.Campus.query_by_municipio()
    |> Database.list()
  end

  def get_campus(id) do
    Database.get(Campus, id)
  end

  ## Cidade

  def create_cidade(attrs) do
    Database.create(Cidade, attrs)
  end

  def get_cidade(id) do
    Database.get(Cidade, id)
  end

  ## Core

  def create_core(attrs) do
    Database.create(Core, attrs)
  end

  def list_cores do
    Database.list(Queries.Core.query())
  end

  def get_core(id) do
    Database.get(Core, id)
  end

  def update_core(%Core{} = core, attrs) do
    Database.update(core, attrs)
  end

  ## LinhaPesquisa

  def create_linha_pesquisa(attrs) do
    Database.create(LinhaPesquisa, attrs)
  end

  def list_linha_pesquisa do
    Database.list(Queries.LinhaPesquisa.query())
  end

  def list_linha_pesquisa_by_core(core_id) do
    core_id
    |> Queries.LinhaPesquisa.query_by_core()
    |> Database.list()
  end

  def get_linha_pesquisa(id) do
    Database.get(LinhaPesquisa, id)
  end

  ## Midia

  def create_midia(attrs) do
    Database.create(Midia, attrs)
  end

  def list_midia do
    Database.list(Queries.Midia.query())
  end

  def get_midia(id) do
    Database.get(Midia, id)
  end

  def update_midia(%Midia{} = midia, attrs) do
    Database.update(midia, attrs)
  end

  ## Pesquisador

  def change_pesquisador(researcher \\ %Pesquisador{}, attrs \\ %{}) do
    Pesquisador.changeset(researcher, attrs)
  end

  def create_pesquisador(attrs) do
    Database.create(Pesquisador, attrs)
  end

  def list_pesquisador do
    Database.list(Queries.Pesquisador.query())
  end

  def get_pesquisador(id) do
    Database.get(Pesquisador, id)
  end

  ## Relatorio

  def change_relatorio(report \\ %Relatorio{}, attrs \\ %{}) do
    Relatorio.changeset(report, attrs)
  end

  def create_relatorio(attrs) do
    Database.create(Relatorio, attrs)
  end

  def list_relatorio do
    Database.list(Queries.Relatorio.query())
  end

  def get_relatorio(ano, mes) do
    Database.get_by(Relatorio, ano: ano, mes: mes)
  end

  ## Generic

  defdelegate delete(source, opts \\ []), to: Fuschia.Database
end
