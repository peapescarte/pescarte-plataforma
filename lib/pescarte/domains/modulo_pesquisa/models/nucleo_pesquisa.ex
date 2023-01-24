defmodule Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa

  schema "nucleo_pesquisa" do
    field :name, CapitalizedString
    field :desc, :string
    field :public_id, :string

    has_many :linha_pesquisas, LinhaPesquisa

    timestamps()
  end
end
