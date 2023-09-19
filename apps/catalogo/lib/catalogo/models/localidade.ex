defmodule Catalogo.Models.Localidade do
  use Database, :model

  alias Catalogo.Models.Comunidade

  @type t :: %Localidade{
          nome: binary,
          descricao: binary,
          comunidade: Comunidade.t(),
          id_publico: binary
        }

  @required_fields ~w(nome descricao comunidade_nome)a

  @primary_key {:nome, :string, autogenerate: false}
  schema "localidade" do
    field :descricao, :string
    field :id_publico, Database.Types.PublicId, autogenerate: true

    belongs_to :comunidade, Comunidade,
      foreign_key: :comunidade_nome,
      references: :nome,
      type: :string

    timestamps()
  end

  @spec changeset(Localidade.t(), map) :: changeset
  def changeset(%Localidade{} = localidade, attrs) do
    localidade
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:comunidade)
  end
end
