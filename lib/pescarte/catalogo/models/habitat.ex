defmodule Pescarte.Catalogo.Models.Habitat do
  use Pescarte, :model

  alias Pescarte.Catalogo.Models.Peixe
  alias Pescarte.Database.Types.PublicId

  @type t :: %Habitat{
          nome: binary,
          peixes: list(Peixe.t()),
          id: binary
        }

  @required_fields ~w(nome)a

  @primary_key {:id, PublicId, autogenerate: true}
  schema "habitat" do
    field :nome, :string

    many_to_many :peixes, Peixe,
      join_through: "peixes_habitats",
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
