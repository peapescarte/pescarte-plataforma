defmodule Fuschia.Entities.Pesquisador do
  @moduledoc """
  Pesquisador Schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Entities.{Pesquisador, Universidade, User}
  alias Fuschia.Types.TrimmedString

  @required_fields ~w(minibiografia tipo_bolsa link_lattes universidade_nome)a
  @optional_fields ~w(orientador_cpf)a

  @tipos_bolsa ~w(ic pesquisa)a

  @primary_key {:usuario_cpf, TrimmedString, []}
  schema "pesquisador" do
    field :minibiografia, :string
    field :tipo_bolsa, Ecto.Enum, values: @tipos_bolsa, default: :pesquisa
    field :link_lattes, :string
    field :orientador_cpf, TrimmedString

    has_many :orientandos, Pesquisador

    belongs_to :usuario, User,
      references: :cpf,
      define_field: false,
      foreign_key: :usuario_cpf,
      type: :string

    belongs_to :universidade, Universidade,
      references: :nome,
      foreign_key: :universidade_nome,
      type: :string

    has_one :orientador, Pesquisador, references: :usuario_cpf, foreign_key: :orientador_cpf

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:minibiografia, max: 280)
    |> cast_assoc(:usuario, required: true)
    |> foreign_key_constraint(:orientador_cpf)
    |> foreign_key_constraint(:universidade_nome)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, opts) do
      %{
        cpf: struct.cpf,
        minibiografia: struct.minibibliografia,
        tipo_bolsa: struct.tipo_bolsa,
        link_lattes: struct.link_lattes,
        orientador: struct.orientador,
        universidade: struct.universidade,
        usuario: struct.usuario,
        orientandos: struct.orientandos
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
