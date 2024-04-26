defmodule Pescarte.CotacoesETL.InjesterSupervisor do
  use Supervisor

  alias Pescarte.CotacoesETL.Workers.PDFConverter
  alias Pescarte.CotacoesETL.Workers.Pesagro.CotacaoDownloader
  alias Pescarte.CotacoesETL.Workers.Pesagro.CotacaoIngester
  alias Pescarte.CotacoesETL.Workers.Pesagro.CotacoesFetcher
  alias Pescarte.CotacoesETL.Workers.ZIPExtractor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_opts) do
    Supervisor.init(children(), strategy: :one_for_one)
  end

  defp children do
    if should_fetch_pesagro_cotacoes?() do
      [
        PDFConverter,
        ZIPExtractor,
        CotacoesFetcher,
        CotacaoDownloader,
        CotacaoIngester,
        {Finch, name: PescarteHTTPClient}
      ]
    else
      []
    end
  end

  defp should_fetch_pesagro_cotacoes? do
    Application.get_env(:pescarte, :fetch_pesagro_cotacoes, false)
  end
end
