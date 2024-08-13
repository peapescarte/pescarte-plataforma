defmodule Pescarte.Application do
  use Application

  @impl true
  def start(_, _) do
    session_opts = [:named_table, :public, read_concurrency: true]
    :ets.new(:pescarte_session, session_opts)
    opts = [strategy: :one_for_one, name: Pescarte.Supervisor]
    Supervisor.start_link(children(), opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PescarteWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp children do
    if Pescarte.env() == :dev, do: Faker.start()

    [
      Pescarte.Database.Supervisor,
      PescarteWeb.Telemetry,
      {Phoenix.PubSub, name: Pescarte.PubSub},
      PescarteWeb.Endpoint,
      Pescarte.CotacoesETL.InjesterSupervisor,
      {Task, fn -> Supabase.init_client!(:pescarte_supabase, supa_config()) end}
    ]
    |> maybe_append_children(Pescarte.env())
  end

  defp maybe_append_children(children, :test), do: children
  # defp maybe_append_children(children, _), do: [ChromicPDF | children]
  defp maybe_append_children(children, _), do: children

  defp supa_config do
    base_url = Application.get_env(:supabase_potion, :supabase_base_url)
    api_key = Application.get_env(:supabase_potion, :supabase_api_key)

    %{conn: %{base_url: base_url, api_key: api_key}}
  end
end
