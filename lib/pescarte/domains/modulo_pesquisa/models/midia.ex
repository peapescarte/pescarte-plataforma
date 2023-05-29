defmodule Pescarte.Domains.ModuloPesquisa.Models.Midia do
  use Pescarte, :model

  alias Pescarte.Domains.Accounts.Models.User
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag
  alias Pescarte.Types.TrimmedString

  @required_fields ~w(tipo nome_arquivo data_arquivo link autor_id)a
  @optional_fields ~w(observacao texto_alternativo restrito?)a
  @update_fields ~w(tipo link nome_arquivo data_arquivo observacao texto_alternativo)a

  @tipos ~w(imagem video documento)a

  schema "midia" do
    field :tipo, Ecto.Enum, values: @tipos
    field :nome_arquivo, TrimmedString
    field :data_arquivo, :date
    field :restrito?, :boolean, default: false
    field :observacao, TrimmedString
    field :link, TrimmedString
    field :texto_alternativo, TrimmedString
    field :id_publico, :string

    belongs_to :autor, User, on_replace: :update

    many_to_many :tags, Tag,
      join_through: "midias_tags",
      on_replace: :delete,
      unique: true

    timestamps()
  end

  def changeset(attrs, tags) do
    %__MODULE__{}
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:link)
    |> unique_constraint(:nome_arquivo)
    |> foreign_key_constraint(:autor_id)
    |> put_assoc(:tags, tags)
    |> put_change(:id_publico, Nanoid.generate())
  end

  def update_changeset(midia, attrs) do
    midia
    |> cast(attrs, @update_fields)
    |> unique_constraint(:nome_arquivo)
    |> unique_constraint(:link)
    |> put_assoc(:tags, attrs[:tags] || midia.tags)
  end

  def list_tags_query(%__MODULE__{} = midia) do
    from m in __MODULE__, where: m.id == ^midia.id, preload: :tags
  end

  def tipos, do: @tipos
end
