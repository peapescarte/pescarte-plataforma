defmodule Pescarte.Supabase do
  defmodule PostgREST do
    use Supabase.PostgREST, client: __MODULE__
  end

  defmodule Auth do
    use Supabase.GoTrue, client: Pescarte.Supabase.Auth
  end

  def start_link(_opts) do
    children = [__MODULE__.Auth, __MODULE__.PostgREST]
    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
end
