defmodule Catalogo.Models.ApetrechoPesca do
  use Database, :model

  alias Catalogo.Models.Peixe

  @type t :: %ApetrechoPesca{
          nome: binary,
          id_publico: binary,
          peixes: list(Peixe.t())
        }

  @required_fields ~w(nome id_publico)a

  @primary_key {:nome, :string, autogenerate: false}
  schema "apetrecho_pesca" do
    field :id_publico, Database.Types.PublicId, autogenerate: true

    many_to_many :peixes, Peixe,
      join_through: "peixes_apetrechos_pesca",
      join_keys: [apetrecho_nome: :nome, peixe_nome_cientifico: :nome_cientifico],
      on_replace: :delete,
      unique: true

    timestamps()
  end

  @spec changeset(ApetrechoPesca.t(), map) :: changeset
  def changeset(%ApetrechoPesca{} = apetrecho_pesca, attrs) do
    apetrecho_pesca
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
