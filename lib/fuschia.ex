defmodule Fuschia do
  @moduledoc """
  Fuschia keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defmodule AppService, do: @callback(process(map | keyword) :: {:ok, term} | {:error, term})

  def application_service do
    quote do
      @behaviour Fuschia.AppService
    end
  end

  def domain_service do
    quote do
    end
  end

  def model do
    quote do
      use Ecto.Schema

      alias Fuschia.Types.CapitalizedString
      alias Fuschia.Types.TrimmedString

      @timestamps_opts [inserted_at: :inserted_at, type: :utc_datetime_usec]

      @self __MODULE__

      @spec new(keyword) :: struct
      def new(params) do
        struct(@self, params)
      end
    end
  end

  def repo do
    quote do
      import Ecto.Changeset
      import Ecto.Query
      import Fuschia.Repo, only: [fetch: 2, fetch_by: 2]

      alias Fuschia.Database

      @behaviour Fuschia.Repo
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
