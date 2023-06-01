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
    field :id_publico, :string

    has_many :linha_pesquisas, LinhaPesquisa

    timestamps()
  end

  @spec changeset(map) :: {:ok, NucleoPesquisa.t()} | {:error, changeset}
  def changeset(nucleo_pesquisa \\ %__MODULE__{}, attrs) do
    nucleo_pesquisa
    |> cast(attrs, [:nome, :desc, :letra])
    |> validate_required([:nome, :desc, :letra])
    |> validate_length(:desc, max: 400)
    |> put_change(:id_publico, Nanoid.generate())
    |> apply_action(:parse)
  end
end
