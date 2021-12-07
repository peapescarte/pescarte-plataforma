defmodule Fuschia.Entites.Midia do
  @moduledoc """
  Midia Schema
  """

  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Entities.Pesquisador
  alias Fuschia.Types.TrimmedString

  @required_fields ~w(
   tipo
   link
   tags
   pesquisador_cpf
  )a

  @primary_key {:link, TrimmedString, autogenerate: false}
  schema "midia" do
    field :tipo, TrimmedString
    field :tags, {:array, TrimmedString}

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
        tipo: struct.tipo,
        link: struct.link,
        tags: struct.tags,
        pesquisador_cpf: struct.pesquisador_cpf
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
