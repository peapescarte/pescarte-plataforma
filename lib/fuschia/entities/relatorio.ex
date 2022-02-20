defmodule Fuschia.Entities.Relatorio do
  @moduledoc """
  Relatorio Schema
  """

  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Accounts.Pesquisador
  alias Fuschia.Types.TrimmedString

  @required_fields ~w(
    ano
    mes
    tipo
    link
    pesquisador_cpf
  )a

  @tipos ~w(mensal trimestral anual)

  @primary_key false

  schema "relatorio" do
    field :id_externo, :string
    field :ano, :integer, primary_key: true
    field :mes, :integer, primary_key: true
    field :tipo, TrimmedString
    field :link, TrimmedString

    belongs_to :pesquisador, Pesquisador,
      references: :usuario_cpf,
      foreign_key: :pesquisador_cpf,
      type: TrimmedString,
      on_replace: :update

    timestamps()
  end

  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_month(:mes)
    |> validate_year(:ano)
    |> validate_inclusion(:tipo, @tipos)
    |> foreign_key_constraint(:pesquisador_cpf)
    |> put_change(:id_externo, Nanoid.generate())
  end

  defp validate_month(changeset, field) do
    month = 1..12

    mth = get_field(changeset, field)

    if mth in month do
      changeset
    else
      add_error(changeset, field, "Mês inválido")
    end
  end

  defp validate_year(changeset, field) do
    today = Date.utc_today()

    year = get_field(changeset, field)

    if year <= today.year do
      changeset
    else
      add_error(changeset, field, "Ano inválido")
    end
  end

  @spec to_map(%__MODULE__{}) :: map
  def to_map(%__MODULE__{} = struct) do
    %{
      id: struct.id_externo,
      ano: struct.ano,
      mes: struct.mes,
      tipo: struct.tipo,
      link: struct.link,
      pesquisador_cpf: struct.pesquisador_cpf
    }
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    alias Fuschia.Entities.Relatorio

    @spec encode(Relatorio.t(), map) :: map
    def encode(struct, opts) do
      struct
      |> Relatorio.to_map()
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
