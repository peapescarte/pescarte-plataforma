defmodule Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.Types.TrimmedString

  @required_fields ~w(nucleo_pesquisa_id sort_desc number)a
  @optional_fields ~w(desc pesquisador_id responsavel_lp_id)a

  schema "linha_pesquisa" do
    field :number, :integer
    field :short_desc, TrimmedString
    field :desc, TrimmedString
    field :public_id, :string

    belongs_to :nucleo_pesquisa, NucleoPesquisa
    belongs_to :pesquisador, Pesquisador
    belongs_to :responsavel_lp, Pesquisador, foreign_key: :responsavel_lp_id

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:short_desc, max: 90)
    |> validate_length(:desc, max: 280)
    |> foreign_key_constraint(:nucleo_pesquisa_id)
    |> foreign_key_constraint(:pesquisador_id)
    |> foreign_key_constraint(:responsavel_lp_id)
    |> put_change(:public_id, Nanoid.generate())
    |> apply_action(:parse)
  end

  def list_linha_pesquisa_by_nucleo_pesquisa_query(nucleo_pesquisa_id) do
    from(l in __MODULE__,
      inner_join: n in assoc(l, :nucleo_pesquisa),
      where: n.id == ^nucleo_pesquisa_id
    )
  end
end
