defmodule Pescarte.Domains.Accounts.Models.User do
  use Pescarte, :model

  alias Pescarte.Domains.Accounts.Models.Contato
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  @valid_roles ~w(pesquisador pescador admin avulso)a

  schema "user" do
    field :cpf, TrimmedString
    field :confirmed_at, :naive_datetime
    field :password_hash, :string, redact: true
    field :password, TrimmedString, virtual: true, redact: true
    field :birthdate, :date
    field :role, Ecto.Enum, default: :avulso, values: @valid_roles
    field :first_name, CapitalizedString
    field :middle_name, CapitalizedString
    field :last_name, CapitalizedString
    field :public_id, :string

    has_one :pesquisador, Pesquisador
    belongs_to :contato, Contato, on_replace: :update

    timestamps()
  end

  def full_name(user) do
    names = [user.first_name, user.middle_name, user.last_name]

    Enum.join(names, " ")
  end

  def user_roles, do: @valid_roles
end
