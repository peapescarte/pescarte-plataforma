defmodule Fuschia.ModuloPesquisa.Models.Pesquisador do
  @moduledoc """
  Pesquisador Schema
  """

  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Accounts.Models.User
  alias Fuschia.ModuloPesquisa.Models.{Campus, Midia, Pesquisador, Relatorio}
  alias Fuschia.Types.TrimmedString

  @required_fields ~w(
    minibiografia
    tipo_bolsa
    link_lattes
    campus_sigla
    usuario_id
  )a

  @optional_fields ~w(orientador_id)a

  @tipos_bolsa ~w(
    ic pesquisa voluntario
    celetista consultoria
    coordenador_tecnico
    doutorado mestrado
    pos_doutorado nsa
    coordenador_pedagogico
  )a

  @primary_key {:id, :string, autogenerate: false}
  schema "pesquisador" do
    field :minibiografia, TrimmedString
    field :tipo_bolsa, Ecto.Enum, values: @tipos_bolsa
    field :link_lattes, TrimmedString

    has_many :orientandos, Pesquisador
    has_many :midias, Midia
    has_many :relatorios, Relatorio

    belongs_to :campus, Campus
    belongs_to :user, User, on_replace: :update
    belongs_to :orientador, Pesquisador, on_replace: :update

    timestamps()
  end

  @doc false
  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:minibiografia, max: 280)
    |> foreign_key_constraint(:usuario_cpf)
    |> foreign_key_constraint(:orientador_cpf)
    |> foreign_key_constraint(:campus_sigla)
    |> put_change(:id, Nanoid.generate())
  end

  @spec update_changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def update_changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_length(:minibiografia, max: 280)
    |> validate_inclusion(:tipo_bolsa, @tipos_bolsa)
    |> foreign_key_constraint(:usuario_cpf)
    |> foreign_key_constraint(:orientador_cpf)
    |> foreign_key_constraint(:campus_sigla)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    alias Fuschia.ModuloPesquisa.Adapters.Pesquisador

    @spec encode(Pesquisador.t(), map) :: map
    def encode(struct, opts) do
      struct
      |> Pesquisador.to_map()
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
