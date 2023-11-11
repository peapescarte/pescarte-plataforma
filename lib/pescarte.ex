defmodule Pescarte do
  def config_env do
    Application.get_env(:pescarte, :config_env)
  end

  def model do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      alias __MODULE__
      alias Pescarte.Database.Types.PublicId
      @typep changeset :: Ecto.Changeset.t()
      @timestamps_opts [inserted_at: :inserted_at, type: :utc_datetime_usec]
    end
  end

  # apenas para semântica
  def schema, do: model()

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
