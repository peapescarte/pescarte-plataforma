defmodule Pescarte.Domains.ModuloPesquisa.Models.Campus do
  use Pescarte, :model

  alias Pescarte.Domains.Accounts.Models.Endereco
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  @type t :: %Campus{
          id: integer,
          nome: binary,
          acronimo: binary,
          id_publico: binary,
          endereco: Endereco.t(),
          nome_universidade: binary,
          pesquisadores: list(Pesquisador.t())
        }

  @required_fields ~w(acronimo endereco_id)a
  @optional_fields ~w(nome nome_universidade)a

  schema "campus" do
    field :nome, :string
    field :nome_universidade, :string
    field :acronimo, :string
    field :id_publico, :string

    has_many :pesquisadores, Pesquisador
    belongs_to :endereco, Endereco, on_replace: :delete

    timestamps()
  end

  @spec changeset(map) :: {:ok, Campus.t()} | {:error, changeset}
  def changeset(campus \\ %__MODULE__{}, attrs) do
    campus
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:nome)
    |> unique_constraint(:acronimo)
    |> foreign_key_constraint(:endereco_id)
    |> put_change(:id_publico, Nanoid.generate())
    |> apply_action(:parse)
  end
end
