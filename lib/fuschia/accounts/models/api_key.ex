defmodule Fuschia.Accounts.Models.ApiKey do
  @moduledoc false

  use Fuschia, :model

  schema "api_key" do
    field :key, Ecto.UUID
    field :description, :string
    field :active, :boolean

    timestamps()
  end
end
