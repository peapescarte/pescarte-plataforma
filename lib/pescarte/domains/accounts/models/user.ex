defmodule Pescarte.Domains.Accounts.Models.User do
  use Pescarte, :model

  alias Pescarte.Domains.Accounts.Models.Contato
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  schema "user" do
    field(:cpf, TrimmedString)
    field(:confirmed_at, :naive_datetime)
    field(:password_hash, :string, redact: true)
    field(:password, TrimmedString, virtual: true, redact: true)
    field(:birthdate, :date)
    field(:last_seen, :utc_datetime_usec)
    field(:role, TrimmedString, default: "avulso")
    field(:first_name, CapitalizedString)
    field(:middle_name, CapitalizedString)
    field(:last_name, CapitalizedString)
    field(:active?, :boolean, default: true)
    field(:permissions, :map, virtual: true)
    field(:public_id, :string)

    has_one(:pesquisador, Pesquisador)
    belongs_to(:contato, Contato, on_replace: :update)

    timestamps()
  end
end
