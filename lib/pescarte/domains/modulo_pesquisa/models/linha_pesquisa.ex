defmodule Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa
  alias Pescarte.Types.TrimmedString

  schema "linha_pesquisa" do
    field :number, :integer
    field :short_desc, TrimmedString
    field :desc, TrimmedString
    field :public_id, :string

    belongs_to :nucleo_pesquisa, NucleoPesquisa

    timestamps()
  end
end
