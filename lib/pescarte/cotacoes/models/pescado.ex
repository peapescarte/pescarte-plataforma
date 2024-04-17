defmodule Pescarte.Cotacoes.Models.Pescado do
  use Pescarte, :model

  alias Pescarte.Database.Types.PublicId

  @type t :: %Pescado{id: binary, codigo: binary, descricao: binary, embalagem: binary}

  @required_fields ~w(codigo)a
  @optional_fields ~w(descricao embalagem)a

  @primary_key {:id, PublicId, autogenerate: true}
  schema "pescado" do
    field :codigo, :string
    field :descricao, :string
    field :embalagem, :string

    timestamps()
  end

  @spec changeset(Pescado.t(), map) :: changeset
  def changeset(%Pescado{} = pescado, attrs) do
    pescado
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
