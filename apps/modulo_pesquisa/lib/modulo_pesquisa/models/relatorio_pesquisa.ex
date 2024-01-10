defmodule ModuloPesquisa.Models.RelatorioPesquisa do
  use Database, :model

  alias ModuloPesquisa.Models.Pesquisador
  alias ModuloPesquisa.Schemas.ConteudoAnual
  alias ModuloPesquisa.Schemas.ConteudoMensal
  alias ModuloPesquisa.Schemas.ConteudoTrimestral

  @type t :: %RelatorioPesquisa{
          tipo: atom,
          data_inicio: Date.t(),
          data_fim: Date.t(),
          data_entrega: Date.t(),
          data_limite: Date.t(),
          link: binary,
          status: atom,
          pesquisador: Pesquisador.t(),
          id_publico: binary
        }

  @tipo ~w(mensal bimestral trimestral anual)a
  @status ~w(entregue atrasado pendente)a

  @required_fields ~w(tipo data_inicio data_fim status pesquisador_id)a
  @optional_fields ~w(data_entrega data_limite link)a

  @primary_key false
  schema "relatorio_pesquisa" do
    field(:link, :string)
    field(:data_inicio, :date, primary_key: true)
    field(:data_fim, :date, primary_key: true)
    field(:data_entrega, :date)
    field(:data_limite, :date)
    field(:tipo, Ecto.Enum, values: @tipo)
    field(:status, Ecto.Enum, values: @status)
    field(:id_publico, Database.Types.PublicId, autogenerate: true)

    embeds_one(:conteudo_anual, ConteudoAnual, source: :conteudo, on_replace: :update)
    embeds_one(:conteudo_mensal, ConteudoMensal, source: :conteudo, on_replace: :update)
    embeds_one(:conteudo_trimestral, ConteudoTrimestral, source: :conteudo, on_replace: :update)

    belongs_to(:pesquisador, Pesquisador,
      on_replace: :update,
      references: :id_publico,
      type: :string,
      primary_key: true
    )

    timestamps()
  end

  def changeset(%RelatorioPesquisa{} = relatorio, attrs) do
    relatorio
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_embed(:conteudo_anual)
    |> cast_embed(:conteudo_mensal)
    |> cast_embed(:conteudo_trimestral)
    |> validate_required(@required_fields)
    |> validate_inclusion(:tipo, @tipo)
    |> validate_inclusion(:status, @status)
    |> foreign_key_constraint(:pesquisador_id)
    |> validate_period()
    |> put_limit_date()
  end

  defp put_limit_date(changeset) do
    report_type = get_field(changeset, :tipo)
    today = Date.utc_today()

    limit_date = ~D[2030-12-10]
#      case report_type do
#        nil -> changeset
#        :mensal -> Date.from_iso8601!("#{today.year}-#{today.month}-15")
#        _ -> Date.from_iso8601!("#{today.year}-#{today.month}-10")
#      end

    put_change(changeset, :data_limite, limit_date)
  end

  defp validate_period(changeset) do
    start_date = get_field(changeset, :data_inicio)
    end_date = get_field(changeset, :data_fim)

    case {start_date, end_date} do
      {start_date, end_date} when is_nil(start_date) or is_nil(end_date) ->
        changeset

      {_, _} ->
        if Date.compare(start_date, end_date) == :gt do
          add_error(changeset, :data_inicio, "A data de início deve ser anterior a data de fim")
        else
          changeset
        end
    end
  end

  defp validate_status(changeset) do
    status = get_field(changeset, :status)

    case status do
      :entregue ->
        add_error(
          changeset,
          :status,
          "O relatório foi marcado como entregue e não é possível fazer novas alterações"
        )

      _ ->
        changeset
    end
  end
end
