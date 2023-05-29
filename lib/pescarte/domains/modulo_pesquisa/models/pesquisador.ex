defmodule Pescarte.Domains.ModuloPesquisa.Models.Pesquisador do
  use Pescarte, :model

  alias Pescarte.Domains.Accounts.Models.User
  alias Pescarte.Domains.ModuloPesquisa.Models.Campus
  alias Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal
  alias Pescarte.Types.TrimmedString

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
  @update_fields ~w(minibio bolsa link_lattes)a

  schema "pesquisador" do
    field :minibio, TrimmedString
    field :bolsa, Ecto.Enum, values: @tipo_bolsas
    field :link_lattes, TrimmedString
    field :link_banner_perfil, :string
    field :link_avatar, :string
    field :link_linkedin, :string
    field :rg, :string
    field :formacao, TrimmedString
    field :data_inicio_bolsa, :date
    field :data_fim_bolsa, :date
    field :data_contratacao, :date
    field :data_termino, :date
    field :id_publico, :string

    has_one :linha_pesquisa, LinhaPesquisa, foreign_key: :responsavel_lp_id

    has_many :orientandos, Pesquisador
    has_many :midias, Midia, foreign_key: :author_id
    has_many :relatorio_mensais, RelatorioMensal

    belongs_to :campus, Campus
    belongs_to :usuario, User, on_replace: :update
    belongs_to :orientador, Pesquisador, on_replace: :update

    timestamps()
  end

  def changeset(attrs) do
    %Pesquisador{}
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:minibio, max: 280)
    |> foreign_key_constraint(:usuario_id)
    |> foreign_key_constraint(:orientador_id)
    |> foreign_key_constraint(:campus_id)
    |> put_change(:id_publico, Nanoid.generate())
  end

  def update_changeset(pesquisador, attrs) do
    pesquisador
    |> cast(attrs, @update_fields)
    |> validate_length(:minibio, max: 280)
  end

  def tipo_bolsas, do: @tipo_bolsas
end
