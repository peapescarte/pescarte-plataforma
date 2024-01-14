defmodule Pescarte.ModuloPesquisa.Models.Campus do
  use Pescarte, :model

  alias Pescarte.Database.Types.PublicId
  alias Pescarte.Identidades.Models.Endereco
  alias Pescarte.ModuloPesquisa.Models.Pesquisador

  @type t :: %Campus{
          nome: binary,
          acronimo: binary,
          id_publico: binary,
          endereco: Endereco.t(),
          nome_universidade: binary,
          pesquisadores: list(Pesquisador.t()),
          id_publico: binary
        }

  @required_fields ~w(acronimo endereco_cep)a
  @optional_fields ~w(nome nome_universidade)a

  @primary_key {:acronimo, :string, autogenerate: false}
  schema "campus" do
    field :nome, :string
    field :nome_universidade, :string
    field :id_publico, PublicId, autogenerate: true

    has_many :pesquisadores, Pesquisador, foreign_key: :campus_acronimo, references: :acronimo

    belongs_to :endereco, Endereco,
      on_replace: :delete,
      foreign_key: :endereco_cep,
      references: :cep,
      type: :string

    timestamps()
  end

  @spec changeset(Campus.t(), map) :: changeset
  def changeset(%Campus{} = campus, attrs) do
    campus
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:nome)
    |> unique_constraint(:acronimo)
    |> foreign_key_constraint(:endereco_cep)
  end
end
