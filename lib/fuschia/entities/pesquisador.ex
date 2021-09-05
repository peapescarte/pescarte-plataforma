defmodule Fuschia.Entities.Pesquisador do
  @moduledoc """
  Pesquisador Schema
  """

  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Entities.{Campus, Pesquisador, User}
  alias Fuschia.Types.{CapitalizedString, TrimmedString}

  @required_fields ~w(minibiografia tipo_bolsa link_lattes campus_nome)a
  @optional_fields ~w(orientador_cpf)a

  @tipos_bolsa ~w(ic pesquisa voluntario)

  @primary_key {:usuario_cpf, TrimmedString, []}
  @foreign_key_type CapitalizedString
  schema "pesquisador" do
    field :minibiografia, TrimmedString
    field :tipo_bolsa, TrimmedString
    field :link_lattes, TrimmedString
    field :orientador_cpf, TrimmedString

    has_many :orientandos, Pesquisador

    belongs_to :usuario, User,
      references: :cpf,
      define_field: false,
      foreign_key: :usuario_cpf,
      type: TrimmedString

    belongs_to :campus, Campus, foreign_key: :campus_nome, references: :nome

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
    |> validate_inclusion(:tipo_bolsa, @tipos_bolsa)
    |> foreign_key_constraint(:orientador_cpf)
    |> foreign_key_constraint(:campus_nome)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, opts) do
      %{
        cpf: struct.cpf,
        minibiografia: struct.minibibliografia,
        tipo_bolsa: struct.tipo_bolsa,
        link_lattes: struct.link_lattes,
        orientador: struct.orientador,
        campus: struct.campus,
        usuario: struct.usuario,
        orientandos: struct.orientandos
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
