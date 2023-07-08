defmodule CotacoesETL.Application do
  use Application

  alias CotacoesETL.Workers.Pesagro.BoletinsFetcher

  @impl true
  def start(_, _) do
    children =
      if config_env() != :test do
        [BoletinsFetcher, {Finch, name: PescarteHTTPClient}]
      else
        [{Finch, name: PescarteHTTPClient}]
      end

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end

  defp config_env do
    Application.get_env(:cotacoes_etl, :config_env)
  end
end
