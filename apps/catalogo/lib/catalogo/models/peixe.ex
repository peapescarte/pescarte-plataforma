defmodule Catalogo.Models.Peixe do
  use Database, :model

  @type t :: %Peixe{
    nome_cientifico: binary,
    nativo?: boolean,
    link_imagem: binary,

  }

  @required_fields ~w(nome_cientifico nativo? link_imagem)

  @primary_key {:nome_cientifico, :string, autogenerate: false}
  schema "peixe" do
    field :link_imagem, :string
    field :nativo?, :boolean, default: false
    timestamps()
  end

  @spec changeset(Peixe.t(), map) :: changeset
  def changeset(%Peixe{} = peixe, attrs) do
    peixe
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end

end
