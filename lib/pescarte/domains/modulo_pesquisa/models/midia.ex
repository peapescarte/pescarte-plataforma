defmodule Pescarte.Domains.ModuloPesquisa.Models.Midia do
  use Pescarte, :model

  alias Pescarte.Domains.Accounts.Models.Usuario
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag
  alias Pescarte.Types.PublicId

  @type t :: %Midia{
          tipo: atom,
          nome_arquivo: binary,
          data_arquivo: Date.t(),
          restrito?: boolean,
          observacao: binary,
          link: binary,
          texto_alternativo: binary,
          id_publico: binary,
          autor: User.t(),
          tags: list(Tag.t())
        }

  @required_fields ~w(tipo nome_arquivo data_arquivo link autor_id)a
  @optional_fields ~w(observacao texto_alternativo restrito?)a

  @tipos ~w(imagem video documento)a

  @primary_key {:link, :string, autogenerate: false}
  schema "midia" do
    field :tipo, Ecto.Enum, values: @tipos
    field :nome_arquivo, :string
    field :data_arquivo, :date
    field :restrito?, :boolean, default: false
    field :observacao, :string
    field :texto_alternativo, :string
    field :id_publico, PublicId, autogenerate: true

    belongs_to :autor, Usuario,
      on_replace: :update,
      foreign_key: :autor_id,
      references: :id_publico,
      type: :string

    many_to_many :tags, Tag,
      join_through: "midias_tags",
      join_keys: [midia_link: :link, tag_etiqueta: :etiqueta],
      on_replace: :delete,
      unique: true

    timestamps()
  end

  @spec changeset(Midia.t(), map, list(Tag.t())) :: changeset
  def changeset(%Midia{} = midia, attrs, tags \\ []) do
    midia
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:link)
    |> unique_constraint(:nome_arquivo)
    |> foreign_key_constraint(:autor_id)
    |> put_assoc(:tags, tags)
  end

  def tipos, do: @tipos
end
