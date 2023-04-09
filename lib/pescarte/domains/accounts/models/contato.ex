defmodule Pescarte.Domains.Accounts.Models.Contato do
  use Pescarte, :model

  @fields ~w(mobile email address)a

  schema "contato" do
    field :mobile, :string
    field :email, :string
    field :address, :string

    timestamps()
  end

  def changeset(contato \\ %__MODULE__{}, attrs) do
    contato
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Pescarte.Repo)
    |> unique_constraint(:email)
  end
end
