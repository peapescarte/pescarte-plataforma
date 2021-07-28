defmodule Fuschia.Entities.ApiKey do
  @moduledoc """
  API Key Schema
  """

  use Fuschia.Schema

  schema "api_key" do
    field :key, Ecto.UUID
    field :description, :string
    field :active, :boolean

    timestamps()
  end
end
