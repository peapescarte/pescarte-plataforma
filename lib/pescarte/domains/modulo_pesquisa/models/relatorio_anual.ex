defmodule Pescarte.Domains.ModuloPesquisa.Models.RelatorioAnual do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  @opaque t :: %RelatorioAnual{
            id: integer,
            plano_de_trabalho: binary,
            resumo: binary,
            introducao: binary,
            embasamento_teorico: binary,
            resultados: binary,
            atividades_academicas: binary,
            atividades_nao_academicas: binary,
            conclusao: binary,
            referencias: binary,
            status: atom,
            link: binary,
            ano: integer,
            mes: integer,
            pesquisador: Pesquisador.t(),
            id_publico: binary
          }

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

  @spec changeset(map) :: Result.t(RelatorioAnual.t(), changeset)
  def changeset(relatorio_anual \\ %__MODULE__{}, attrs) do
    relatorio_anual
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:pesquisador_id)
    |> put_change(:id_publico, Nanoid.generate())
    |> apply_action(:parse)
  end
end
