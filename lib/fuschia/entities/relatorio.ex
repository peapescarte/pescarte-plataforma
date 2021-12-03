defmodule Fuschia.Entities.Relatorio do
  @moduledoc """
  Relatorio Schema
  """

  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Entities.Pesquisador
  alias Fuschia.Types.TrimmedString

  @required_fields ~w{
    ano
    mes
    tipo_relatorio
    link
    pesquisador_cpf
  }a

  @primary_key {:ano, TrimmedString, autogenerate: false}
  schema "relatorio" do
    field :mes, TrimmedString
    field :tipo_relatorio, TrimmedString
    field :link, TrimmedString

    belongs_to :pesquisador, Pesquisador,
      references: :usuario_cpf,
      foreign_key: :pesquisador_cpf,
      type: TrimmedString,
      on_replace: :update

    timestamps()
  end

  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:pesquisador_cpf)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, opts) do
      %{
        ano: struct.ano,
        mes: struct.mes,
        tipo_relatorio: struct.tipo_relatorio,
        link: struct.link,
        pesquisador_cpf: struct.pesquisador_cpf
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
