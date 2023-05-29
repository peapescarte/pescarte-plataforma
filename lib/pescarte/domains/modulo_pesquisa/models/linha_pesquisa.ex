defmodule Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.Types.TrimmedString

  @required_fields ~w(nucleo_pesquisa_id desc_curta numero)a
  @optional_fields ~w(desc responsavel_lp_id)a

  schema "linha_pesquisa" do
    field :numero, :integer
    field :desc_curta, TrimmedString
    field :desc, TrimmedString
    field :id_publico, :string

    belongs_to :nucleo_pesquisa, NucleoPesquisa
    belongs_to :responsavel_lp, Pesquisador, foreign_key: :responsavel_lp_id

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:desc_curta, max: 90)
    |> validate_length(:desc, max: 280)
    |> foreign_key_constraint(:nucleo_pesquisa_id)
    |> foreign_key_constraint(:responsavel_lp_id)
    |> put_change(:id_publico, Nanoid.generate())
  end

  def list_linha_pesquisa_by_nucleo_pesquisa_query(nucleo_pesquisa_id) do
    from(l in __MODULE__,
      inner_join: n in assoc(l, :nucleo_pesquisa),
      where: n.id == ^nucleo_pesquisa_id
    )
  end
end
