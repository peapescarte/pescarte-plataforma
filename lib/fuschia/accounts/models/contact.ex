defmodule Fuschia.Accounts.Models.Contact do
  use Fuschia, :model

  schema "contact" do
    field :mobile, :string
    field :email, :string
    field :address, :string

    timestamps()
  end
end
