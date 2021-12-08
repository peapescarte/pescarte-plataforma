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

  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:link)
    |> foreign_key_constraint(:pesquisador_cpf)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    @spec encode(%Fuschia.Entites.Midia{}, map) :: map
    def encode(struct, opts) do
      Fuschia.Encoder.encode(
        %{
          tipo: struct.tipo,
          link: struct.link,
          tags: struct.tags
        },
        opts
      )
    end
  end
end
