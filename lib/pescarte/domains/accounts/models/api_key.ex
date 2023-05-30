defmodule Pescarte.Domains.Accounts.Models.ApiKey do
  @moduledoc false

  use Pescarte, :model

  @opaque t :: %ApiKey{
            id: integer,
            key: binary,
            description: binary,
            active: boolean
          }

  schema "api_key" do
    field :key, Ecto.UUID
    field :description, :string
    field :active, :boolean, default: true

    timestamps()
  end

  @spec changeset(map) :: Result.t(ApiKey.t(), changeset)
  def changeset(attrs) do
    %ApiKey{}
    |> cast(attrs, [:key, :description, :active])
    |> validate_required([:key, :description])
    |> apply_action(:parse)
  end
end
