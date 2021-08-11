defmodule Fuschia.Entities.Pesquisador do
  @moduledoc """
  Pesquisador Schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Entities.{Pesquisador, Universidade, User}
  alias Fuschia.Types.TrimmedString

  @required_fields ~w(cpf_usuario minibibliografia tipo_bolsa link_lattes universidade_id)a
  @optional_fields ~w(orientador_id)a

  @tipos_bolsa ~w(ic pesquisador)

  @primary_key {:cpf_usuario, TrimmedString, []}
  schema "pesquisador" do
    field :minibibliografia, :string
    field :tipo_bolsa, :string
    field :link_lattes, :string
    field :orientador_id, TrimmedString

    has_one :orientador, Pesquisador, references: :cpf_usuario, foreign_key: :orientador_id
    has_many :orientandos, Pesquisador
    belongs_to :usuario, User, references: :cpf, define_field: false, foreign_key: :cpf_usuario
    belongs_to :universidade, Universidade, references: :nome, foreign_key: :universidade_id

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:tipo_bolsa, @tipos_bolsa)
    |> validate_length(:minibibliografia, max: 280)
    |> foreign_key_constraint(:orientador_id)
    |> foreign_key_constraint(:cpf_usuario)
    |> foreign_key_constraint(:universidade_id)
    |> unique_constraint(:cpf_usuario)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, opts) do
      %{
        cpf: struct.cpf_usuario,
        minibibliografia: struct.minibibliografia,
        tipo_bolsa: struct.tipo_bolsa,
        link_lattes: struct.link_lattes,
        orientador: struct.orientador,
        universidade: struct.universidade
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
