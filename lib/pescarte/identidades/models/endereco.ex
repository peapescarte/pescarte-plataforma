defmodule Pescarte.Identidades.Models.Endereco do
  use Pescarte, :model

  @type t :: %Endereco{
          rua: binary,
          numero: integer,
          complemento: binary,
          cep: binary,
          cidade: binary,
          estado: binary
        }

  @fields ~w(rua numero complemento cep cidade estado bairro)a

  @primary_key {:cep, :string, autogenerate: false}
  schema "endereco" do
    field(:bairro, :string)
    field(:rua, :string)
    field(:numero, :string)
    field(:complemento, :string)
    field(:cidade, :string)
    field(:estado, :string)
    field(:id_publico, Pescarte.Database.Types.PublicId, autogenerate: true)

    timestamps()
  end

  @spec changeset(Endereco.t(), map) :: changeset
  def changeset(%Endereco{} = endereco, attrs) do
    endereco
    |> cast(attrs, @fields)
    |> validate_required([:cep])
  end
end
