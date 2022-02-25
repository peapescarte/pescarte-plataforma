defmodule Fuschia.ModuloPesquisa do
  @moduledoc """
  Módulo com funções públicas que realizam ações
  do contexto.
  """

  import Fuschia.Common.Database

  alias __MODULE__.Models.{
    Campus,
    Cidade,
    LinhaPesquisa,
    Midia,
    Nucleo,
    Pesquisador,
    Relatorio
  }

  alias __MODULE__.Queries

  # ---------------------------#
  # Database
  # ---------------------------#

  def create_campus(attrs) do
    with_queries_mod(&create_and_preload/3, [Campus, attrs])
  end

  def list_campus do
    with_queries_mod(&list_entity/2, [Campus])
  end

  def get_campus(id) do
    with_queries_mod(&get_entity/3, [Campus, id])
  end

  ## Cidade

  def create_cidade(attrs) do
    with_queries_mod(&create_and_preload/3, [Cidade, attrs])
  end

  def get_cidade(id) do
    with_queries_mod(&get_entity/3, [Cidade, id])
  end

  ## LinhaPesquisa

  def create_linha_pesquisa(attrs) do
    with_queries_mod(&create_and_preload/3, [LinhaPesquisa, attrs])
  end

  def list_linha_pesquisa do
    with_queries_mod(&list_entity/2, [LinhaPesquisa])
  end

  def list_linha_pesquisa_by_nucleo(nucleo_id) do
    with_queries_mod(&list_entity/2, [LinhaPesquisa],
      query_func: :query_by_nucleo,
      query_args: nucleo_id
    )
  end

  def get_linha_pesquisa(id) do
    with_queries_mod(&get_entity/3, [LinhaPesquisa, id])
  end

  ## Midia

  def create_midia(attrs) do
    with_queries_mod(&create_and_preload/3, [Midia, attrs])
  end

  def list_midia do
    with_queries_mod(&list_entity/2, [Midia])
  end

  def get_midia(id) do
    with_queries_mod(&get_entity/3, [Midia, id])
  end

  ## Nucleo

  def create_nucleo(attrs) do
    with_queries_mod(&create_and_preload/3, [Nucleo, attrs])
  end

  def list_nucleo do
    with_queries_mod(&list_entity/2, [Nucleo])
  end

  def get_nucleo(id) do
    with_queries_mod(&get_entity/3, [Nucleo, id])
  end

  ## Pesquisador

  def create_pesquisador(attrs) do
    with_queries_mod(&create_and_preload/3, [Pesquisador, attrs])
  end

  def list_pesquisador do
    with_queries_mod(&list_entity/2, [Pesquisador])
  end

  def get_pesquisador(id) do
    with_queries_mod(&get_entity/3, [Pesquisador, id])
  end

  ## Relatorio

  def create_relatorio(attrs) do
    with_queries_mod(&create_and_preload/3, [Relatorio, attrs])
  end

  def list_relatorio do
    with_queries_mod(&list_entity/2, [Relatorio])
  end

  def get_relatorio(id) do
    with_queries_mod(&get_entity/3, [Relatorio, id])
  end

  ## Generic

  defdelegate delete(source, opts \\ []), to: Fuschia.Database

  # ---------------------------#
  # Internal
  # ---------------------------#

  defp with_queries_mod(func, initial_args, opts \\ []) do
    # credo:disable-for-next-line Credo.Check.Refactor.AppendSingleItem
    apply(func, initial_args ++ [[queries_mod: Queries] ++ opts])
  end
end
