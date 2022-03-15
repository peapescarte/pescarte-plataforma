defmodule Fuschia.ModuloPesquisa.Models.Relatorio do
  @moduledoc """
  Relatorio Schema
  """

  use Fuschia.Schema

  import Ecto.Changeset
  import Fuschia.ModuloPesquisa.Logic.Relatorio

  alias Fuschia.ModuloPesquisa.Models.Pesquisador
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
    field :id, :string
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
    |> put_change(:id, Nanoid.generate())
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    alias Fuschia.ModuloPesquisa.Adapters.Relatorio

    @spec encode(Relatorio.t(), map) :: map
    def encode(struct, opts) do
      struct
      |> Relatorio.to_map()
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
