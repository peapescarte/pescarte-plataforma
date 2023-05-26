defmodule Pescarte do
  @moduledoc """
  Pescarte keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defmodule AppService do
    @callback process(map | keyword) :: {:ok, term} | {:error, term}
    @callback process(map | keyword, atom) :: {:ok, term} | {:error, term}

    @optional_callbacks [process: 2]
  end

  def application_service do
    quote do
      alias Pescarte.Repo

      @behaviour Pescarte.AppService
    end
  end

  def domain_service do
    quote do
    end
  end

  def model do
    quote do
      use Ecto.Schema

      import Ecto.Changeset
      import Ecto.Query

      alias Pescarte.Types.CapitalizedString
      alias Pescarte.Types.TrimmedString

      @timestamps_opts [inserted_at: :inserted_at, type: :utc_datetime_usec]
    end
  end

  def repo do
    quote do
      alias Pescarte.Database

      import Ecto.Query

      @behaviour Pescarte.Repo
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
