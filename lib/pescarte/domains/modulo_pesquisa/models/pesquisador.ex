defmodule Pescarte.Domains.ModuloPesquisa.Models.Pesquisador do
  use Pescarte, :model

  alias Pescarte.Domains.Accounts.Models.User
  alias Pescarte.Domains.ModuloPesquisa.Models.Campus
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.Types.TrimmedString

  @bursary_types ~w(
    ic pesquisa voluntario
    celetista consultoria
    coordenador_tecnico
    doutorado mestrado
    pos_doutorado nsa
    coordenador_pedagogico
  )a

  schema "pesquisador" do
    field :minibio, TrimmedString
    field :bursary, Ecto.Enum, values: @bursary_types
    field :link_lattes, TrimmedString
    field :public_id, :string

    has_many :advisored, Pesquisador
    has_many :midias, Midia
    has_many :relatorio_mensais, RelatorioMensal

    belongs_to :campus, Campus
    belongs_to :user, User, on_replace: :update
    belongs_to :advisor, Pesquisador, on_replace: :update

    timestamps()
  end

  def bursary_types, do: @bursary_types
end
