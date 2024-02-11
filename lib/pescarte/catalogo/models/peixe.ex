defmodule Pescarte.Catalogo.Models.Peixe do
  use Pescarte, :model

  alias Pescarte.Catalogo.Models.Habitat

  @type t :: %Peixe{
          nome_cientifico: binary,
          nativo?: boolean,
          link_imagem: binary,
          habitats: list(Habitat.t()),
          id: binary
        }

  @required_fields ~w(nome_cientifico nativo? link_imagem)a

  @primary_key {:nome_cientifico, :string, autogenerate: false}
  schema "peixe" do
    field(:link_imagem, :string)
    field(:nativo?, :boolean, default: false)
    field(:id, Pescarte.Database.Types.PublicId, autogenerate: true)

    many_to_many(:habitats, Habitat,
      join_through: "peixes_habitats",
      join_keys: [peixe_nome_cientifico: :nome_cientifico, habitat_nome: :nome],
      on_replace: :delete,
      unique: true
    )

    timestamps()
  end

  @spec changeset(Peixe.t(), map) :: changeset
  def changeset(%Peixe{} = peixe, attrs) do
    peixe
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
