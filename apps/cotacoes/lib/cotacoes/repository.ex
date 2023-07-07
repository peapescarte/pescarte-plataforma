defmodule Cotacoes.Repository do
  use Database, :repository

  alias Cotacoes.Models.Cotacao
  alias Cotacoes.Models.CotacaoPescado
  alias Cotacoes.Models.Pescado

  @behaviour Cotacoes.IManageRepository

  @impl true
  def find_all_cotacao_by_is_ingested do
    query = from c in Cotacao, where: c.importada?, select: c
    Repo.Replica.all(query)
  end

  @impl true
  def insert_all_cotacao(cotacoes_attrs) do
    {_amount, _} = Repo.insert_all(Cotacao, cotacoes_attrs)
    :ok
  end

  @impl true
  def list_cotacao do
    Repo.Replica.all(Cotacao)
  end

  @impl true
  def update_all_cotacao(cotacoes, fields) do
    ids = Enum.map(cotacoes, & &1.id)
    query = from c in Cotacao, where: c.id in ^ids, select: c
    {_amount, updated} = Repo.update_all(query, set: fields)
    {:ok, updated}
  end

  @impl true
  def upsert_cotacao(cotacao \\ %Cotacao{}, attrs) do
    cotacao
    |> Cotacao.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @impl true
  def upsert_cotacao_pescado(cot_pescado \\ %CotacaoPescado{}, attrs) do
    cot_pescado
    |> CotacaoPescado.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @impl true
  def insert_all_pescado(pescados) do
    {_amount, _} = Repo.insert_all(Pescado, pescados)
    :ok
  end

  @impl true
  def list_pescado do
    Repo.Replica.all(Pescado)
  end

  @impl true
  def upsert_pescado(pescado \\ %Pescado{}, attrs) do
    pescado
    |> Pescado.changeset(attrs)
    |> Repo.insert_or_update()
  end
end
