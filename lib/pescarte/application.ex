defmodule Pescarte.Application do
  use Application

  alias Pescarte.CotacoesETL.Workers.PDFConverter
  alias Pescarte.CotacoesETL.Workers.Pesagro.CotacaoDownloader
  alias Pescarte.CotacoesETL.Workers.Pesagro.CotacaoIngester
  alias Pescarte.CotacoesETL.Workers.Pesagro.CotacoesFetcher
  alias Pescarte.CotacoesETL.Workers.ZIPExtractor

  def start(_start, _type) do
    children = [
      Pescarte.Database.Repo,
      Pescarte.Database.Repo.Replica,
      {Phoenix.PubSub, name: Pescarte.PubSub},
      PescarteWeb.Endpoint,
      {Finch, name: PescarteHTTPClient}
    ] ++ cotacoes_etl_children()

    opts = [strategy: :one_for_one, name: Pescarte.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp cotacoes_etl_children do
    if config_env() != :test and should_fetch_pesagro_cotacoes?() do
      [
        PDFConverter,
        ZIPExtractor,
        CotacoesFetcher,
        CotacaoDownloader,
        CotacaoIngester,

      ]
      else
      []
    end
  end

  def config_change(changed, _new, removed) do
    PescarteWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp config_env do
    Application.get_env(:pescarte, :config_env)
  end

  defp should_fetch_pesagro_cotacoes? do
    Application.get_env(:pescarte, :fetch_pesagro_cotacoes, false)
  end

end
