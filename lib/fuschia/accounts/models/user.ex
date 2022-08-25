defmodule Fuschia.Accounts.Models.User do
  @moduledoc """
  Schema que representa um usuário do sistema.

  ## Exemplos
  - Pesquisador
  - Pescador
  """
  use Fuschia, :model

  alias Fuschia.Accounts.Models.Contato
  alias Fuschia.ModuloPesquisa.Models.Pesquisador

  @primary_key {:id, :string, autogenerate: false}
  schema "user" do
    field :cpf, TrimmedString
    field :confirmed_at, :naive_datetime
    field :password_hash, :string, redact: true
    field :password, TrimmedString, virtual: true, redact: true
    field :data_nascimento, :date
    field :last_seen, :utc_datetime_usec
    field :role, TrimmedString, default: "avulso"
    field :nome_completo, CapitalizedString
    field :ativo?, :boolean, default: true
    field :permissoes, :map, virtual: true

    has_one :pesquisador, Pesquisador
    belongs_to :contato, Contato, on_replace: :update

    timestamps()
  end
end
