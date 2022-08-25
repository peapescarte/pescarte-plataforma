defmodule Fuschia.ModuloPesquisa do
  @moduledoc """
  Módulo com funções públicas que realizam ações
  do contexto.
  """

  alias Fuschia.ModuloPesquisa.IO.RelatorioRepo
  alias Fuschia.ModuloPesquisa.Services.CreateCampus
  alias Fuschia.ModuloPesquisa.Services.CreateCidade
  alias Fuschia.ModuloPesquisa.Services.CreateLinhaPesquisa
  alias Fuschia.ModuloPesquisa.Services.CreateMidia
  alias Fuschia.ModuloPesquisa.Services.CreateNucleo
  alias Fuschia.ModuloPesquisa.Services.CreatePesquisador
  alias Fuschia.ModuloPesquisa.Services.CreateRelatorio
  alias Fuschia.ModuloPesquisa.Services.GetCampus
  alias Fuschia.ModuloPesquisa.Services.GetCidade
  alias Fuschia.ModuloPesquisa.Services.GetLinhaPesquisa
  alias Fuschia.ModuloPesquisa.Services.GetMidia
  alias Fuschia.ModuloPesquisa.Services.GetNucleo
  alias Fuschia.ModuloPesquisa.Services.GetPesquisador
  alias Fuschia.ModuloPesquisa.Services.GetRelatorio
  alias Fuschia.ModuloPesquisa.Services.UpdateMidia
  alias Fuschia.ModuloPesquisa.Services.UpdateNucleo

  defdelegate create_campus(params), to: CreateCampus, as: :process

  defdelegate get_campus(id), to: GetCampus, as: :process

  defdelegate list_campus, to: GetCampus, as: :process

  defdelegate create_cidade(params), to: CreateCidade, as: :process

  defdelegate get_cidade(id), to: GetCidade, as: :process

  defdelegate create_linha_pesquisa(params), to: CreateLinhaPesquisa, as: :process

  defdelegate get_linha_pesquisa(id), to: GetLinhaPesquisa, as: :process

  defdelegate list_linha_pesquisa, to: GetLinhaPesquisa, as: :process

  defdelegate create_midia(params), to: CreateMidia, as: :process

  defdelegate get_midia(id), to: GetMidia, as: :process

  defdelegate list_midia, to: GetMidia, as: :process

  defdelegate update_midia(params), to: UpdateMidia, as: :process

  defdelegate create_nucleo(params), to: CreateNucleo, as: :process

  defdelegate get_nucleo(id), to: GetNucleo, as: :process

  defdelegate list_nucleo, to: GetNucleo, as: :process

  defdelegate update_nucleo(params), to: UpdateNucleo, as: :process

  defdelegate create_pesquisador(params), to: CreatePesquisador, as: :process

  defdelegate get_pesquisador(id), to: GetPesquisador, as: :process

  defdelegate list_pesquisador, to: GetPesquisador, as: :process

  defdelegate create_relatorio(params), to: CreateRelatorio, as: :process

  defdelegate get_relatorio(id), to: GetRelatorio, as: :process

  defdelegate list_relatorio, to: GetRelatorio, as: :process

  def change_relatorio(report, attrs \\ %{}) do
    RelatorioRepo.changeset(report, attrs)
  end

  def list_campus_by_municipio(id) do
    GetCampus.process(municipio: id)
  end

  def list_linha_pesquisa_by_nucleo(core_id) do
    GetLinhaPesquisa.process(nucleo: core_id)
  end

  ## Generic

  defdelegate delete(source), to: Fuschia.Database
end
