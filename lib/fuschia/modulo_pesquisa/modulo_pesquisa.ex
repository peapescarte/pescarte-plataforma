defmodule Fuschia.ModuloPesquisa do
  @moduledoc """
  Módulo com funções públicas que realizam ações
  do contexto.
  """

  import Fuschia.Database,
    only: [create_and_preload: 3, list_entity: 2, get_entity: 3, update_and_preload: 3]

  alias __MODULE__.Models.{
    CampusModel,
    CidadeModel,
    LinhaPesquisaModel,
    MidiaModel,
    NucleoModel,
    PesquisadorModel,
    RelatorioModel
  }

  alias __MODULE__.Queries

  # ---------------------------#
  # Database
  # ---------------------------#

  def create_campus(attrs) do
    with_queries_mod(&create_and_preload/3, [CampusModel, attrs])
  end

  def list_campus do
    with_queries_mod(&list_entity/2, [CampusModel])
  end

  def get_campus(id) do
    with_queries_mod(&get_entity/3, [CampusModel, id])
  end

  ## Cidade

  def create_cidade(attrs) do
    with_queries_mod(&create_and_preload/3, [CidadeModel, attrs])
  end

  def get_cidade(id) do
    with_queries_mod(&get_entity/3, [CidadeModel, id])
  end

  ## LinhaPesquisa

  def create_linha_pesquisa(attrs) do
    with_queries_mod(&create_and_preload/3, [LinhaPesquisaModel, attrs])
  end

  def list_linha_pesquisa do
    with_queries_mod(&list_entity/2, [LinhaPesquisaModel])
  end

  def list_linha_pesquisa_by_nucleo(nucleo_id) do
    with_queries_mod(&list_entity/2, [LinhaPesquisaModel],
      query_fun: :query_by_nucleo,
      query_args: nucleo_id
    )
  end

  def get_linha_pesquisa(id) do
    with_queries_mod(&get_entity/3, [LinhaPesquisaModel, id])
  end

  ## Midia

  def create_midia(attrs) do
    with_queries_mod(&create_and_preload/3, [MidiaModel, attrs])
  end

  def list_midia do
    with_queries_mod(&list_entity/2, [MidiaModel])
  end

  def get_midia(id) do
    with_queries_mod(&get_entity/3, [MidiaModel, id])
  end

  def update_midia(%MidiaModel{} = midia, attrs, change_fun \\ :changeset) do
    with_queries_mod(&update_and_preload/3, [midia, attrs, change_fun: change_fun])
  end

  ## Nucleo

  def create_nucleo(attrs) do
    with_queries_mod(&create_and_preload/3, [NucleoModel, attrs])
  end

  def list_nucleo do
    with_queries_mod(&list_entity/2, [NucleoModel])
  end

  def get_nucleo(id) do
    with_queries_mod(&get_entity/3, [NucleoModel, id])
  end

  def update_nucleo(%NucleoModel{} = nucleo, attrs, change_fun \\ :changeset) do
    with_queries_mod(&update_and_preload/3, [nucleo, attrs, change_fun: change_fun])
  end

  ## Pesquisador

  def create_pesquisador(attrs) do
    with_queries_mod(&create_and_preload/3, [PesquisadorModel, attrs])
  end

  def list_pesquisador do
    with_queries_mod(&list_entity/2, [PesquisadorModel])
  end

  def get_pesquisador(id) do
    with_queries_mod(&get_entity/3, [PesquisadorModel, id])
  end

  ## Relatorio

  def create_relatorio(attrs) do
    with_queries_mod(&create_and_preload/3, [RelatorioModel, attrs])
  end

  def list_relatorio do
    with_queries_mod(&list_entity/2, [RelatorioModel])
  end

  def get_relatorio(id) do
    with_queries_mod(&get_entity/3, [RelatorioModel, id])
  end

  ## Generic

  defdelegate delete(source, opts \\ []), to: Fuschia.Database

  # ---------------------------#
  # Internal
  # ---------------------------#

  defp with_queries_mod(fun, initial_args, opts \\ []) do
    # credo:disable-for-next-line Credo.Check.Refactor.AppendSingleItem
    apply(fun, initial_args ++ [[queries_mod: Queries] ++ opts])
  end
end
