defmodule Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa

  @type t :: %NucleoPesquisa{
          id: integer,
          nome: binary,
          letra: binary,
          desc: binary,
          id_publico: binary,
          linha_pesquisas: list(LinhaPesquisa.t())
        }

  schema "nucleo_pesquisa" do
    field :nome, :string
    field :letra, :string
    field :desc, :string
    field :id_publico, Pescarte.Types.PublicId, autogenerate: true

    has_many :linha_pesquisas, LinhaPesquisa

    timestamps()
  end

  @spec changeset(NucleoPesquisa.t(), map) :: changeset
  def changeset(%NucleoPesquisa{} = nucleo_pesquisa, attrs) do
    nucleo_pesquisa
    |> cast(attrs, [:nome, :desc, :letra])
    |> validate_required([:nome, :desc, :letra])
    |> validate_length(:desc, max: 400)
    |> unique_constraint([:nome, :letra])
  end
end
