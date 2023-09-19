defmodule ModuloPesquisa.Models.RelatorioPesquisa do
  use Database, :model

  alias ModuloPesquisa.Models.Pesquisador

  @type t :: %RelatorioPesquisa{
          tipo: atom,
          conteudo: map,
          inicio_periodo: Date.t(),
          fim_periodo: Date.t(),
          link: binary,
          status: atom,
          pesquisador: Pesquisador.t(),
          id_publico: binary
        }

  @tipo ~w(mensal bimestral trimestral anual)a
  @status ~w(entregue atrasado pendente)a

  @required_fields ~w(tipo conteudo inicio_periodo fim_periodo status pesquisador_id)a
  @optional_fields ~w(link)a

  @primary_key false

  schema "relatorio_pesquisa" do
    field :tipo, Ecto.Enum, values: @tipo
    field :conteudo, :map
    field :inicio_periodo, :date
    field :fim_periodo, :date
    field :link, :string
    field :status, Ecto.Enum, values: @status
    field :id_publico, Database.Types.PublicId, autogenerate: true

    belongs_to :pesquisador, Pesquisador,
      on_replace: :update,
      references: :id_publico,
      type: :string

    timestamps()
  end

  @spec changeset(RelatorioPesquisa.t(), map) :: changeset
  def changeset(%RelatorioPesquisa{} = relatorio, attrs) do
    relatorio
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:tipo, @tipo)
    |> validate_inclusion(:status, @status)
    |> foreign_key_constraint(:pesquisador_id)
  end
end
