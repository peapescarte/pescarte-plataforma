defmodule CotacoesETL.Application do
  use Application

  alias CotacoesETL.Workers.PDFConverter
  alias CotacoesETL.Workers.Pesagro.BoletimDownloader
  alias CotacoesETL.Workers.Pesagro.BoletinsFetcher
  alias CotacoesETL.Workers.ZIPExtractor

  @impl true
  def start(_, _) do
    children =
      if config_env() != :test or should_fetch_pesagro_cotacoes?() do
        [
          PDFConverter,
          ZIPExtractor,
          BoletinsFetcher,
          BoletimDownloader,
          {Finch, name: PescarteHTTPClient}
        ]
      else
        [{Finch, name: PescarteHTTPClient}]
      end

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end

  defp config_env do
    Application.get_env(:cotacoes_etl, :config_env)
  end

  defp should_fetch_pesagro_cotacoes? do
    Application.get_env(:cotacoes_etl, :fetch_pesagro_cotacoes, false)
  end
end
