defmodule Pescarte.Identidades.Models.Endereco do
  use Pescarte, :model

  @type t :: %Endereco{
          id: binary,
          rua: binary,
          cep: binary,
          cidade: binary,
          estado: binary
        }

  @fields ~w(rua cep cidade estado)a

  @primary_key {:id, Pescarte.Database.Types.PublicId, autogenerate: true}
  schema "endereco" do
    field(:rua, :string)
    field(:cep, :string)
    field(:cidade, :string)
    field(:estado, :string)
    # field(:id, Pescarte.Database.Types.PublicId, autogenerate: true)

    timestamps()
  end

  @spec changeset(Endereco.t(), map) :: changeset
  def changeset(%Endereco{} = endereco, attrs) do
    endereco
    |> cast(attrs, @fields)
    |> validate_required([:cep])
    |> validate_required([:rua])
    |> validate_required([:cidade])
    |> validate_required([:estado])
    |> unique_constraint(:id)
  end
end
