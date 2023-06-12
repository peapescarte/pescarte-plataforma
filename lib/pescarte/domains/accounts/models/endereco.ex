defmodule Pescarte.Domains.Accounts.Models.Endereco do
  use Pescarte, :model

  @type t :: %Endereco{
          id: integer,
          rua: binary,
          numero: integer,
          complemento: binary,
          cep: binary,
          cidade: binary,
          estado: binary
        }

  @fields ~w(rua numero complemento cep cidade estado)a

  schema "endereco" do
    field :rua, :string
    field :numero, :integer
    field :complemento, :string
    field :cep, :string
    field :cidade, :string
    field :estado, :string

    timestamps()
  end

  @spec changeset(map) :: Result.t(Endereco.t(), changeset)
  def changeset(endereco \\ %__MODULE__{}, attrs) do
    endereco
    |> cast(attrs, @fields)
    |> validate_required([:cep])
    |> apply_action(:parse)
  end
end
