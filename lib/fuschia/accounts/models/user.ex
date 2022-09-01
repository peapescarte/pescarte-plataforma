defmodule Fuschia.Accounts.Models.User do
  use Fuschia, :model

  alias Fuschia.Accounts.Models.Contact
  alias Fuschia.ResearchModulus.Models.Researcher

  schema "user" do
    field :cpf, TrimmedString
    field :confirmed_at, :naive_datetime
    field :password_hash, :string, redact: true
    field :password, TrimmedString, virtual: true, redact: true
    field :birthdate, :date
    field :last_seen, :utc_datetime_usec
    field :role, TrimmedString, default: "avulso"
    field :first_name, CapitalizedString
    field :middle_name, CapitalizedString
    field :last_name, CapitalizedString
    field :active?, :boolean, default: true
    field :permissions, :map, virtual: true
    field :public_id, :string

    has_one :researcher, Researcher
    belongs_to :contact, Contact, on_replace: :update

    timestamps()
  end
end
