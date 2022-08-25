defmodule Fuschia.ModuloPesquisa.Models.Pesquisador do
  @moduledoc """
  Pesquisador Schema
  """

  use Fuschia, :model

  alias Fuschia.Accounts.Models.User
  alias Fuschia.ModuloPesquisa.Models.Campus
  alias Fuschia.ModuloPesquisa.Models.Midia
  alias Fuschia.ModuloPesquisa.Models.Pesquisador
  alias Fuschia.ModuloPesquisa.Models.Relatorio
  alias Fuschia.Types.TrimmedString

  @tipos_bolsa ~w(
    ic pesquisa voluntario
    celetista consultoria
    coordenador_tecnico
    doutorado mestrado
    pos_doutorado nsa
    coordenador_pedagogico
  )a

  @primary_key {:id, :string, autogenerate: false}
  schema "pesquisador" do
    field :minibiografia, TrimmedString
    field :tipo_bolsa, Ecto.Enum, values: @tipos_bolsa
    field :link_lattes, TrimmedString

    has_many :orientandos, Pesquisador
    has_many :midias, Midia
    has_many :relatorios, Relatorio

    belongs_to :campus, Campus
    belongs_to :user, User, on_replace: :update
    belongs_to :orientador, Pesquisador, on_replace: :update

    timestamps()
  end
end
