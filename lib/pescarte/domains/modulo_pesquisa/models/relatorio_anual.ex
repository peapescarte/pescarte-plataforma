defmodule Pescarte.Domains.ModuloPesquisa.Models.RelatorioAnual do
  use Pescarte, :model

  import Pescarte.Domains.ModuloPesquisa.Services.ValidateRelatorioMensal

  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  @status ~w(entregue atrasado nao_enviado)a

  @required_fields ~w(ano mes pesquisador_id)a

  @optional_fields ~w(
    plano_de_trabalho
    resumo
    introducao
    embasamento_teorico
    resultados
    atividades_academicas
    atividades_nao_academicas
    conclusao
    referencias
    status
    link
  )a

  @update_fields @optional_fields ++ ~w(year month link)a

  schema "relatorio_anual_pesquisa" do
    field :ano, :integer
    field :mes, :integer
    field :link, :string
    field :id_publico, :string
    field :status, Ecto.Enum, values: @status, default: :nao_enviado

    field :plano_de_trabalho, :string
    field :resumo, :string
    field :introducao, :string
    field :embasamento_teorico, :string
    field :resultados, :string
    field :atividades_academicas, :string
    field :atividades_nao_academicas, :string
    field :conclusao, :string
    field :referencias, :string

    belongs_to :pesquisador, Pesquisador, on_replace: :update

    timestamps()
  end

  def changeset(report \\ %__MODULE__{}, attrs) do
    report
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_month(:mes)
    |> validate_year(:ano, Date.utc_today())
    |> foreign_key_constraint(:pesquisador_id)
    |> put_change(:id_publico, Nanoid.generate())
  end

  def update_changeset(report, attrs) do
    report
    |> cast(attrs, @update_fields)
    |> validate_month(:mes)
    |> validate_year(:ano, Date.utc_today())
  end
end
