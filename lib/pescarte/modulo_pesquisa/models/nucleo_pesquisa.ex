defmodule Pescarte.ModuloPesquisa.Models.NucleoPesquisa do
  use Pescarte, :model
  use SwissSchema, repo: Pescarte.Database.Repo

  alias Pescarte.Database.Types.PublicId
  alias Pescarte.ModuloPesquisa.Models.LinhaPesquisa

  @type t :: %NucleoPesquisa{
          nome: binary,
          letra: binary,
          desc: binary,
          id: binary,
          linha_pesquisas: list(LinhaPesquisa.t())
        }

  @primary_key {:id, PublicId, autogenerate: true}
  schema "nucleo_pesquisa" do
    field :nome, :string
    field :desc, :string
    field :letra, :string

    has_many :linha_pesquisas, LinhaPesquisa

    timestamps()
  end

  @spec changeset(NucleoPesquisa.t(), map) :: changeset
  def changeset(nucleo_pesquisa \\ %NucleoPesquisa{}, attrs) do
    nucleo_pesquisa
    |> cast(attrs, [:nome, :desc, :letra])
    |> validate_required([:nome, :desc, :letra])
    |> unique_constraint([:nome, :letra])
  end
end
