defmodule Pescarte.ModuloPesquisa.Models.NucleoPesquisa do
  use Pescarte, :model

  alias Pescarte.ModuloPesquisa.Models.LinhaPesquisa

  @type t :: %NucleoPesquisa{
          nome: binary,
          letra: binary,
          desc: binary,
          id: binary,
          linha_pesquisas: list(LinhaPesquisa.t())
        }

  @primary_key {:letra, :string, autogenerate: false}
  schema "nucleo_pesquisa" do
    field(:nome, :string)
    field(:desc, :string)
    field(:id, Pescarte.Database.Types.PublicId, autogenerate: true)

    has_many(:linha_pesquisas, LinhaPesquisa, foreign_key: :nucleo_pesquisa_letra)

    timestamps()
  end

  @spec changeset(NucleoPesquisa.t(), map) :: changeset
  def changeset(%NucleoPesquisa{} = nucleo_pesquisa, attrs) do
    nucleo_pesquisa
    |> cast(attrs, [:nome, :desc, :letra])
    |> validate_required([:nome, :desc, :letra])
    # |> validate_length(:desc, max: 400)
    |> unique_constraint([:nome, :letra])
  end
end
