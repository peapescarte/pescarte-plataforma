defmodule Catalogo.Models.ApetrechoPesca do
  use Database, :model

  @type t :: %ApetrechoPesca{
          nome: binary,
          id_publico: binary
        }

  @required_fields ~w(nome id_publico)a

  @primary_key {:nome, :string, autogenerate: false}
  schema "apetrecho_pesca" do
    field :id_publico, Database.Types.PublicId, autogenerate: true

    timestamps()
  end

  @spec changeset(ApetrechoPesca.t(), map) :: changeset
  def changeset(%ApetrechoPesca{} = apetrecho_pesca, attrs) do
    apetrecho_pesca
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
