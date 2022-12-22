defmodule Pescarte.Accounts.Models.Contact do
  use Pescarte, :model

  schema "contact" do
    field :mobile, :string
    field :email, :string
    field :address, :string
    # field :cep, :string

    timestamps()
  end
end
