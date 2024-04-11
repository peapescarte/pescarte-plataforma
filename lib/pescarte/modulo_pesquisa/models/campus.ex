defmodule Pescarte.ModuloPesquisa.Models.Campus do
  use Pescarte, :model

  alias Pescarte.Database.Types.PublicId
  alias Pescarte.ModuloPesquisa.Models.Pesquisador

  @type t :: %Campus{
          nome: binary,
          acronimo: binary,
          id: binary,
          endereco: String.t(),
          nome_universidade: binary,
          pesquisadores: list(Pesquisador.t())
        }

  @required_fields ~w(acronimo endereco nome nome_universidade)a

  @primary_key {:id, PublicId, autogenerate: true}
  schema "campus" do
    field :acronimo, :string
    field :nome, :string
    field :nome_universidade, :string
    field :endereco, :string

    has_many :pesquisadores, Pesquisador

    timestamps()
  end

  @spec changeset(Campus.t(), map) :: changeset
  def changeset(campus \\ %Campus{}, attrs) do
    campus
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:acronimo, max: 20)
  end
end
