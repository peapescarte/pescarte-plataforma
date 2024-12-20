defmodule Pescarte do
  @spec env :: :dev | :test | :prod
  def env do
    Application.get_env(:pescarte, :env)
  end

  @spec get_supabase_client :: {:ok, Supabase.Client.t()} | {:error, term}
  def get_supabase_client do
    Pescarte.Supabase.get_client()
  end

  def get_static_file_path(folder, file) do
    :pescarte
    |> :code.priv_dir()
    |> List.to_string()
    |> then(&Path.join([&1, "static", folder, file]))
  end

  def model do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Ecto.Query
      alias Pescarte.Database
      alias Pescarte.Database.Replica
      alias Pescarte.Database.Repo
      alias __MODULE__
      @typep changeset :: Ecto.Changeset.t()
      @timestamps_opts [inserted_at: :inserted_at, type: :utc_datetime_usec]
    end
  end

  def repository do
    quote do
      import Ecto.Query
      alias Pescarte.Database.Repo
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
