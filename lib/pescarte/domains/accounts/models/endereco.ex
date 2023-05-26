defmodule Pescarte.Domains.Accounts.Models.Endereco do
  use Pescarte, :model

  alias Pescarte.Types.CapitalizedString

  @fields ~w(rua numero complemento cep cidade estado)a

  @cep_format ~r/\d{5}-\d{3}/

  schema "endereco" do
    field :rua, CapitalizedString
    field :numero, :integer
    field :complemento, :string
    field :cep, :string
    field :cidade, CapitalizedString
    field :estado, CapitalizedString

    timestamps()
  end

  def changeset(endereco \\ %__MODULE__{}, attrs) do
    endereco
    |> cast(attrs, @fields)
    |> validate_required([:cep])
    |> validate_format(:cep, @cep_format)
  end
end
