defmodule Pescarte.Catalogo.Models.Habitat do
  use Pescarte, :model

  alias Pescarte.Catalogo.Models.Peixe

  @type t :: %Habitat{
          nome: binary,
          peixes: list(Peixe.t()),
          id_publico: binary
        }

  @required_fields ~w(nome)a

  @primary_key {:nome, :string, autogenerate: false}
  schema "habitat" do
    field :id_publico, PublicId, autogenerate: true

    many_to_many :peixes, Peixe,
      join_through: "peixes_habitats",
      join_keys: [habitat_nome: :nome, peixe_nome_cientifico: :nome_cientifico],
      on_replace: :delete,
      unique: true

    timestamps()
  end

  @spec changeset(Habitat.t(), map) :: changeset
  def changeset(%Habitat{} = habitat, attrs) do
    habitat
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:nome)
  end
end
