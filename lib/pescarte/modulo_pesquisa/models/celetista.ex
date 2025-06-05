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

  @derive {
    Flop.Schema,
    filterable: ~w(nome cpf email)a,
    sortable: ~w(nome email)a,
    adapter_opts: [
      join_fields: [
        nome: [
          binding: :usuario,
          field: :primeiro_nome,
          ecto_type: :string
        ],
        cpf: [
          binding: :usuario,
          field: :cpf,
          ecto_type: :string
        ],
        email: [
          binding: :contato,
          field: :email_principal,
          ecto_type: :string,
          path: [:usuario, :contato]
        ]
      ]
    ]
  }

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
