defmodule Pescarte.ModuloPesquisa.Models.PesquisadorLP do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pescarte.ModuloPesquisa.Models.LinhaPesquisa
  alias Pescarte.ModuloPesquisa.Models.Pesquisador

  @already_exists "ALREADY_EXISTS"

  schema "pesquisador_lp" do
    belongs_to(:pesquisador, Pesquisador, primary_key: true)
    belongs_to(:linha_pesquisa, LinhaPesquisa, primary_key: true)
    field(:lider?, :boolean, default: false)
    timestamps()
  end

  @required_fields ~w(pesquisador linha_pesquisa)a
  def changeset(pesquisador_lp, attrs) do
    pesquisador_lp
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:pesquisador)
    |> foreign_key_constraint(:linha_pesquisa)
    |> unique_constraint([:pesquisador, :linha_pesquisa],
      name: :pesquisador_linhapequisa_unique_index,
      message: @already_exists
    )
  end
end
