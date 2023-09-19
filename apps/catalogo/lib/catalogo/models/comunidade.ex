defmodule Catalogo.Models.Comunidade do
  use Database, :model

  alias Catalogo.Models.Localidade
  alias Identidades.Models.Endereco

  @type t :: %Comunidade{
          nome: binary,
          descricao: binary,
          endereco: Endereco.t(),
          localidades: list(Localidade.t()),
          id_publico: binary
        }

  @required_fields ~w(nome descricao endereco_cep)a

  @primary_key {:nome, :string, autogenerate: false}
  schema "comunidade" do
    field :descricao, :string
    field :id_publico, Database.Types.PublicId, autogenerate: true

    belongs_to :endereco, Endereco,
      foreign_key: :endereco_cep,
      references: :cep,
      type: :string

    has_many :localidades, Localidade,
      foreign_key: :comunidade_nome,
      references: :nome

    timestamps()
  end

  @spec changeset(Comunidade.t(), map) :: changeset
  def changeset(%Comunidade{} = comunidade, attrs) do
    comunidade
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
