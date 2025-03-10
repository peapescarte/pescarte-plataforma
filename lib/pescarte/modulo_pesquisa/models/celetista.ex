defmodule Pescarte.ModuloPesquisa.Models.Celetista do
  use Pescarte, :model

  alias Pescarte.Database.Types.PublicId
  alias Pescarte.Identidades.Models.Usuario

  @type t :: %Celetista{
          id: binary,
          equipe: String.t(),
          usuario: Usuario.t()
        }

  @fields ~w(equipe usuario_id)a

  @primary_key {:id, PublicId, autogenerate: true}
  schema "celetista" do
    field :equipe, :string

    belongs_to :usuario, Usuario, type: :string

    timestamps()
  end

  @spec changeset(Celetista.t(), map) :: changeset
  def changeset(celetista \\ %Celetista{}, attrs) do
    celetista
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> cast_assoc(:usuario, required: true)
    |> foreign_key_constraint(:usuario_id)
  end
end
