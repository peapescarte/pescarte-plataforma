defmodule Pescarte.Cotacoes.Repository do
  use Pescarte, :repository

  alias Pescarte.Cotacoes.Models.Cotacao
  alias Pescarte.Cotacoes.Models.CotacaoPescado
  alias Pescarte.Cotacoes.Models.Fonte
  alias Pescarte.Cotacoes.Models.Pescado

  @behaviour Pescarte.Cotacoes.IManageRepository

  @impl true
  def find_all_cotacao_by_not_ingested do
    query = from c in Cotacao, where: not c.importada?, select: c
    Repo.Replica.all(query)
  end

  @impl true
  def fetch_cotacao_by_link(link) do
    Pescarte.Database.fetch_by(Cotacao, link: link)
  end

  @impl true
  def fetch_cotacao_pescado_by(fields) do
    Pescarte.Database.fetch_by(CotacaoPescado, fields)
  end

  @impl true
  def fetch_cotacao_by_id(id) do
    Pescarte.Database.fetch_by(Cotacao, id: id)
  end

  @impl true
  def fetch_pescado_by_codigo(codigo) do
    Pescarte.Database.fetch_by(Pescado, codigo: codigo)
  end

  @impl true
  def fetch_fonte_by_nome(nome) do
    Pescarte.Database.fetch_by(Fonte, nome: nome)
  end

  @impl true
  def find_all_cotacao_by_not_downloaded do
    query = from c in Cotacao, where: not c.baixada?, select: c
    Repo.Replica.all(query)
  end

  @impl true
  def insert_fonte_cotacao(attrs) do
    %Fonte{}
    |> Fonte.changeset(attrs)
    |> Repo.insert()
  end

  @impl true
  def insert_cotacao(attrs) do
    %Cotacao{}
    |> Cotacao.changeset(attrs)
    |> Repo.insert()
  end

  @impl true
  def list_cotacao do
    Repo.Replica.all(Cotacao)
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
