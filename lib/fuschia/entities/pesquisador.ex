defmodule Fuschia.Entities.Pesquisador do
  @moduledoc """
  Pesquisador Schema
  """

  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Entities.{Campus, Midia, Pesquisador, User}
  alias Fuschia.Types.{CapitalizedString, TrimmedString}

  @required_fields ~w(
    minibiografia
    tipo_bolsa
    link_lattes
    campus_nome
  )a

  @optional_fields ~w(orientador_cpf)a

  @tipos_bolsa ~w(ic pesquisa voluntario)

  @primary_key {:usuario_cpf, TrimmedString, autogenerate: false}
  schema "pesquisador" do
    field :minibiografia, TrimmedString
    field :tipo_bolsa, TrimmedString
    field :link_lattes, TrimmedString

    has_many :orientandos, Pesquisador, foreign_key: :orientador_cpf

    has_many :midias, Midia

    belongs_to :usuario, User,
      references: :cpf,
      foreign_key: :usuario_cpf,
      type: TrimmedString,
      primary_key: true,
      define_field: false,
      on_replace: :update

    belongs_to :campus, Campus,
      foreign_key: :campus_nome,
      references: :nome,
      type: CapitalizedString

    belongs_to :orientador, Pesquisador,
      references: :usuario_cpf,
      foreign_key: :orientador_cpf,
      type: TrimmedString,
      on_replace: :update

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:minibiografia, max: 280)
    |> validate_inclusion(:tipo_bolsa, @tipos_bolsa)
    |> cast_assoc(:usuario, required: true)
    |> foreign_key_constraint(:orientador_cpf)
    |> foreign_key_constraint(:campus_nome)
  end

  def update_changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required([:minibiografia, :link_lattes, :campus_nome])
    |> validate_length(:minibiografia, max: 280)
    |> validate_inclusion(:tipo_bolsa, @tipos_bolsa)
    |> put_assoc(:usuario, attrs["usuario"])
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
