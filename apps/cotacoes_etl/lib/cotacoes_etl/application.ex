defmodule CotacoesETL.Application do
  use Application

  alias CotacoesETL.Workers.Pesagro.BoletinsFetcher

  @impl true
  def start(_, _) do
    children = [BoletinsFetcher, {Finch, name: PescarteHTTPClient}]
    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
  end
end
