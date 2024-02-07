defmodule Pescarte.ModuloPesquisa.Models.Campus do
  use Pescarte, :model

  alias Pescarte.Database.Types.PublicId
  alias Pescarte.Identidades.Models.Endereco
  alias Pescarte.ModuloPesquisa.Models.Pesquisador

  @type t :: %Campus{
          nome: binary,
          acronimo: binary,
          id: binary,
          endereco_id: Endereco.t(),
          nome_universidade: binary,
          pesquisadores: list(Pesquisador.t())
        }

  @required_fields ~w(acronimo endereco_id nome nome_universidade)a
  # @optional_fields ~w(nome nome_universidade)a

  @primary_key {:id, PublicId, autogenerate: true}
  schema "campus" do
    field(:acronimo, :string)
    field(:nome, :string)
    field(:nome_universidade, :string)
    # field(:id_publico, PublicId, autogenerate: true)

    has_many(:pesquisadores, Pesquisador, foreign_key: :campus_id, references: :id)

    belongs_to(:endereco, Endereco,
      on_replace: :delete,
      foreign_key: :endereco_id,
      references: :id,
      type: PublicId
    )

    timestamps()
  end

  @spec changeset(Campus.t(), map) :: changeset
  def changeset(%Campus{} = campus, attrs) do
    campus
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    # |> unique_constraint(:nome) tem varios campi na mesma cidade e cidade costuma ser o nome
    |> validate_length(:acronimo, max: 20)
    |> unique_constraint(:id)
    |> foreign_key_constraint(:endereco_id)
  end
end
