defmodule Pescarte.Domains.Accounts.Models.Contato do
  use Pescarte, :model

  schema "contato" do
    field :mobile, :string
    field :email, :string
    field :address, :string

    timestamps()
  end
end
