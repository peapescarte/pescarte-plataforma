defmodule Pescarte do
  @moduledoc """
  Pescarte keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def model do
    quote do
      use Ecto.Schema
      alias Monads.Result
      alias __MODULE__
      import Ecto.Changeset
      @typep changeset :: Ecto.Changeset.t()
      @timestamps_opts [inserted_at: :inserted_at, type: :utc_datetime_usec]
    end
  end

  def repository do
    quote do
      alias Pescarte.Repo
      import Ecto.Query
    end
  end

  def service do
    quote do
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
