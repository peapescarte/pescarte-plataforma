defmodule Catalogo.Models.NomesComunsPeixe do
  use Database, :model

  alias Catalogo.Models.Comunidade
  alias Catalogo.Models.Peixe

  @type t :: %NomesComunsPeixe{
          nome_comum: binary,
          peixe: Peixe.t(),
          comunidade: Comunidade.t(),
          validado?: boolean
        }

  @required_fields ~w(nome_comum nome_cientifico comunidade_nome validado?)a

  @primary_key false
  schema "nomes_comuns_peixe" do
    field :nome_comum, :string, primary_key: true
    field :nome_cientifico_key, :string, primary_key: true, source: :nome_cientifico
    field :comunidade_nome_key, :string, primary_key: true, source: :comunidade_nome
    field :validado?, :boolean, default: false

    belongs_to :peixe, Peixe,
      foreign_key: :nome_cientifico,
      type: :string

    belongs_to :comunidade, Comunidade,
      foreign_key: :comunidade_nome,
      type: :string

    timestamps()
  end

  @spec changeset(NomesComunsPeixe.t(), map) :: changeset
  def changeset(%NomesComunsPeixe{} = nome_comum, attrs) do
    nome_comum
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
