defmodule Pescarte.Domains.ModuloPesquisa.Models.Pesquisador do
  use Pescarte, :model

  alias Monads.Maybe
  alias Pescarte.Domains.Accounts.Models.User
  alias Pescarte.Domains.ModuloPesquisa.Models.Campus
  alias Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal

  @type t :: %Pesquisador{
          id: integer,
          minibio: binary,
          bolsa: atom,
          link_lattes: binary,
          link_banner_perfil: binary,
          link_avatar: binary,
          link_linkedin: binary,
          rg: binary,
          formacao: binary,
          data_inicio_bolsa: Date.t(),
          data_fim_bolsa: Date.t(),
          data_contratacao: Date.t(),
          data_termino: Date.t(),
          id_publico: binary,
          linha_pesquisa: LinhaPesquisa.t(),
          orientandos: list(Pesquisador.t()),
          orientador: Maybe.t(Pesquisador.t()),
          midias: list(Midia.t()),
          relatorio_mensais: list(RelatorioMensal.t()),
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

  @required_fields ~w(minibio bolsa link_lattes campus_id usuario_id rg data_inicio_bolsa data_fim_bolsa data_contratacao formacao)a
  @optional_fields ~w(orientador_id link_avatar link_banner_perfil link_linkedin data_termino)a

  schema "pesquisador" do
    field :minibio, :string
    field :bolsa, Ecto.Enum, values: @tipo_bolsas
    field :link_lattes, :string
    field :link_banner_perfil, :string
    field :link_avatar, :string
    field :link_linkedin, :string
    field :rg, :string
    field :formacao, :string
    field :data_inicio_bolsa, :date
    field :data_fim_bolsa, :date
    field :data_contratacao, :date
    field :data_termino, :date
    field :id_publico, :string

    has_one :linha_pesquisa, LinhaPesquisa, foreign_key: :responsavel_lp_id

    has_many :orientandos, Pesquisador
    has_many :midias, Midia, foreign_key: :autor_id
    has_many :relatorio_mensais, RelatorioMensal

    belongs_to :campus, Campus
    belongs_to :usuario, User, on_replace: :update
    belongs_to :orientador, Pesquisador, on_replace: :update

    timestamps()
  end

  @spec changeset(map) :: Result.t(Pesquisador.t(), changeset)
  def changeset(pesquisador \\ %Pesquisador{}, attrs) do
    pesquisador
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:usuario_id)
    |> foreign_key_constraint(:orientador_id)
    |> foreign_key_constraint(:campus_id)
    |> put_change(:id_publico, Nanoid.generate())
    |> apply_action(:parse)
  end

  def tipo_bolsas, do: @tipo_bolsas
end
