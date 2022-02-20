defmodule Fuschia.Entities.Midia do
  @moduledoc """
  Midia Schema
  """

  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Accounts.Pesquisador
  alias Fuschia.Types.TrimmedString

  @required_fields ~w(
   tipo
   link
   tags
   pesquisador_cpf
  )a

  @tipos_midia ~w(video imagem documento)

  @primary_key {:link, TrimmedString, autogenerate: false}
  schema "midia" do
    field :id_externo, :string
    field :tipo, TrimmedString
    field :tags, {:array, TrimmedString}

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
    |> unique_constraint(:link)
    |> validate_inclusion(:tipo, @tipos_midia)
    |> foreign_key_constraint(:pesquisador_cpf)
    |> put_change(:id_externo, Nanoid.generate())
  end

  @spec to_map(%__MODULE__{}) :: map
  def to_map(%__MODULE__{} = struct) do
    %{
      id: struct.id_externo,
      tipo: struct.tipo,
      link: struct.link,
      tags: struct.tags
    }
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    alias Fuschia.Entities.Midia

    @spec encode(Midia.t(), map) :: map
    def encode(struct, opts) do
      struct
      |> Midia.to_map()
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
