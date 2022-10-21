defmodule Backend.Accounts.Models.Contact do
  use Backend, :model

  schema "contact" do
    field :mobile, :string
    field :email, :string
    field :address, :string

    timestamps()
  end
end
