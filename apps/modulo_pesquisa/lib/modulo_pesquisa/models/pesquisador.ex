defmodule ModuloPesquisa.Models.Pesquisador do
  use Database, :model

  alias Identidades.Models.Usuario
  alias ModuloPesquisa.Models.Campus
  alias ModuloPesquisa.Models.LinhaPesquisa
  alias ModuloPesquisa.Models.Midia
  alias ModuloPesquisa.Models.RelatorioPesquisa

  @type t :: %Pesquisador{
          minibio: binary,
          bolsa: atom,
          link_lattes: binary,
          link_banner_perfil: binary,
          link_avatar: binary,
          link_linkedin: binary,
          formacao: binary,
          data_inicio_bolsa: Date.t(),
          data_fim_bolsa: Date.t(),
          data_contratacao: Date.t(),
          data_termino: Date.t(),
          id_publico: binary,
          linha_pesquisa: LinhaPesquisa.t(),
          orientandos: list(Pesquisador.t()),
          orientador: Pesquisador.t() | nil,
          midias: list(Midia.t()),
          relatorios_pesquisa: list(RelatorioPesquisa.t()),
          campus: Campus.t(),
          usuario: User.t()
        }

  @tipo_bolsas ~w(
    ic pesquisa voluntario
    celetista consultoria
    coordenador_tecnico
    doutorado mestrado
    pos_doutorado nsa
    coordenador_pedagogico
  )a

  @required_fields ~w(minibio bolsa link_lattes campus_acronimo usuario_id data_inicio_bolsa data_fim_bolsa data_contratacao formacao)a
  @optional_fields ~w(orientador_id link_avatar link_banner_perfil link_linkedin data_termino)a

  @primary_key {:id_publico, Database.Types.PublicId, autogenerate: true}
  schema "pesquisador" do
    field :minibio, :string
    field :bolsa, Ecto.Enum, values: @tipo_bolsas
    field :link_lattes, :string
    field :link_banner_perfil, :string
    field :link_avatar, :string
    field :link_linkedin, :string
    field :formacao, :string
    field :data_inicio_bolsa, :date
    field :data_fim_bolsa, :date
    field :data_contratacao, :date
    field :data_termino, :date

    has_one :linha_pesquisa, LinhaPesquisa,
      foreign_key: :responsavel_lp_id,
      references: :id_publico

    has_many :relatorios_pesquisa, RelatorioPesquisa,
      references: :id_publico,
      foreign_key: :pesquisador_id

    has_many :orientandos, Pesquisador, references: :id_publico

    has_many :midias, Midia,
      foreign_key: :autor_id,
      references: :id_publico,
      foreign_key: :pesquisador_id

    belongs_to :usuario, Usuario,
      on_replace: :update,
      references: :id_publico,
      foreign_key: :usuario_id,
      type: :string

    belongs_to :campus, Campus,
      foreign_key: :campus_acronimo,
      references: :acronimo,
      type: :string

    belongs_to :orientador, Pesquisador,
      on_replace: :update,
      references: :id_publico,
      foreign_key: :orientador_id,
      type: :string

    timestamps()
  end

  @spec changeset(Pesquisador.t(), map) :: changeset
  def changeset(%Pesquisador{} = pesquisador, attrs) do
    pesquisador
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:minibio, max: 280)
    |> unique_constraint(:rg)
    |> foreign_key_constraint(:usuario_id)
    |> foreign_key_constraint(:orientador_id)
    |> foreign_key_constraint(:campus_acronimo)
  end

  def tipo_bolsas, do: @tipo_bolsas
end
