defmodule Backend do
  @moduledoc """
  Backend keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  defmodule AppService, do: @callback(process(map | keyword) :: {:ok, term} | {:error, term})

  def application_service do
    quote do
      @behaviour Backend.AppService
    end
  end

  def domain_service do
    quote do
    end
  end

  def model do
    quote do
      use Ecto.Schema

      alias Backend.Types.CapitalizedString
      alias Backend.Types.TrimmedString

      @timestamps_opts [inserted_at: :inserted_at, type: :utc_datetime_usec]
    end
  end

  def repo do
    quote do
      import Ecto.Changeset
      import Ecto.Query
      import Backend.Repo, only: [fetch: 2, fetch_by: 2]

      alias Backend.Database

      @behaviour Backend.Repo
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
