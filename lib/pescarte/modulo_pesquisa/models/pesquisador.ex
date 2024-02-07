defmodule Pescarte.ModuloPesquisa.Models.Pesquisador do
  use Pescarte, :model

  alias Pescarte.Identidades.Models.Usuario
  alias Pescarte.ModuloPesquisa.Models.Campus
  alias Pescarte.ModuloPesquisa.Models.Midia
  alias Pescarte.ModuloPesquisa.Models.RelatorioPesquisa
  alias Pescarte.Database.Types.PublicId

  @type t :: %Pesquisador{
          minibio: binary,
          bolsa: atom,
          link_lattes: binary,
          link_banner_perfil: binary,
          link_linkedin: binary,
          formacao: binary,
          data_inicio_bolsa: Date.t(),
          data_fim_bolsa: Date.t(),
          data_contratacao: Date.t(),
          data_termino: Date.t(),
          id: binary,
          orientandos: list(Pesquisador.t()),
          orientador: Pesquisador.t() | nil,
          midias: list(Midia.t()),
          relatorios_pesquisa: list(RelatorioPesquisa.t()),
          campus_id: Campus.t(),
          usuario: User.t(),
          anotacoes: binary
        }

  @tipo_bolsas ~w(
    ic pesquisa consultoria
    voluntario
    celetista
    coordenador_tecnico
    doutorado mestrado
    pos_doutorado nsa
    coordenador_pedagogico
  )a

  #  esses aqui nao entram no sistema e nao tem no cadatro: voluntario  celetista

  @required_fields ~w(bolsa link_lattes campus_id usuario_id data_inicio_bolsa data_contratacao formacao)a
  @optional_fields ~w(orientador_id link_banner_perfil link_linkedin data_fim_bolsa data_termino)a

  @primary_key {:id, Pescarte.Database.Types.PublicId, autogenerate: true}
  schema "pesquisador" do
    field(:minibio, :string)
    field(:bolsa, Ecto.Enum, values: @tipo_bolsas)
    field(:link_lattes, :string)
    field(:link_banner_perfil, :string)
    field(:link_linkedin, :string)
    field(:formacao, :string)
    field(:data_inicio_bolsa, :date)
    field(:data_fim_bolsa, :date)
    field(:data_contratacao, :date)
    field(:data_termino, :date)
    field(:anotacoes, :string)

    has_many(:relatorios_pesquisa, RelatorioPesquisa,
      references: :id,
      foreign_key: :pesquisador_id
    )

    has_many(:orientandos, Pesquisador, references: :id)

    has_many(:midias, Midia,
      foreign_key: :autor_id,
      references: :id,
      foreign_key: :pesquisador_id
    )

    belongs_to(:usuario, Usuario,
      on_replace: :update,
      references: :id,
      foreign_key: :usuario_id,
      type: :string
    )

    belongs_to(:campus, Campus,
      # on_replace: :update,
      foreign_key: :campus_id,
      references: :id,
      type: PublicId
    )

    belongs_to(:orientador, Pesquisador,
      on_replace: :update,
      references: :id,
      foreign_key: :orientador_id,
      type: :string
    )

    timestamps()
  end

  @spec changeset(Pesquisador.t(), map) :: changeset
  def changeset(%Pesquisador{} = pesquisador, attrs) do
    pesquisador
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    # |> validate_length(:minibio, max: 280)
    |> unique_constraint(:rg)
    |> foreign_key_constraint(:usuario_id)
    |> foreign_key_constraint(:orientador_id)
    |> foreign_key_constraint(:campus_id)
  end

  def tipo_bolsas, do: @tipo_bolsas
end
