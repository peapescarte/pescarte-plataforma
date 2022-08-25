defmodule Fuschia.Accounts.Models.Contato do
  @moduledoc """
  Contato schema
  """

  use Fuschia, :model

  schema "contato" do
    field :celular, :string
    field :email, :string
    field :endereco, :string

    timestamps()
  end
end
