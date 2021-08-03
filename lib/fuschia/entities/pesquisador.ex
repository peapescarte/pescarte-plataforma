defmodule Fuschia.Entities.Pesquisador do
  @moduledoc """
  Pesquisador Schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Entities.Pesquisador
  alias Fuschia.Entities.Universidade
  alias Fuschia.Entities.User
  alias Fuschia.Types.TrimmedString

  @required_fields ~w(cpf_usuario minibibliografia tipo_bolsa link_lattes id_universidade)a
  @optional_fields ~w(cod_orientador)a

  @primary_key {:cpf_usuario, TrimmedString, []}
  schema "pesquisador" do
    field :minibibliografia, :string
    field :tipo_bolsa, :string
    field :link_lattes, :string
    field :cod_orientador, TrimmedString

    has_one :orientador, Pesquisador, references: :cpf_usuario, foreign_key: :cod_orientador
    belongs_to :usuario, User, references: :cpf, define_field: false, foreign_key: :cpf_usuario
    belongs_to :id_universidade, Universidade

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:cod_orientador)
    |> foreign_key_constraint(:cpf_usuario)
    |> foreign_key_constraint(:universidade_id)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, opts) do
      %{
        cpf_usuario: struct.nome,
        minibibliografia: struct.minibibliografia,
        tipo_bolsa: struct.tipo_bolsa,
        link_lattes: struct.link_lattes,
        cod_orientador: struct.cod_orientador,
        id_universidade: struct.id_universidade
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
