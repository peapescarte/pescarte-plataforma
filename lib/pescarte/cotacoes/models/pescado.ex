defmodule Pescarte.Cotacoes.Models.Pescado do
  use Pescarte, :model

  @type t :: %Pescado{id: binary, codigo: binary, descricao: binary, embalagem: binary}

  @required_fields ~w(codigo)a
  @optional_fields ~w(descricao embalagem)a

  @primary_key {:codigo, :string, autogenerate: false}
  schema "pescado" do
    field(:descricao, :string)
    field(:embalagem, :string)
    field(:id, Pescarte.Database.Types.PublicId, autogenerate: true)
  end

  @spec changeset(Pescado.t(), map) :: changeset
  def changeset(%Pescado{} = pescado, attrs) do
    pescado
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
