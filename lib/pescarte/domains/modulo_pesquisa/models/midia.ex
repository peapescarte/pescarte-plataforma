defmodule Pescarte.Domains.ModuloPesquisa.Models.Midia do
  use Pescarte, :model

  alias Pescarte.Domains.Accounts.Models.User
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  @type t :: %Midia{
          id: integer,
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

  schema "midia" do
    field :tipo, Ecto.Enum, values: @tipos
    field :nome_arquivo, :string
    field :data_arquivo, :date
    field :restrito?, :boolean, default: false
    field :observacao, :string
    field :link, :string
    field :texto_alternativo, :string
    field :id_publico, :string

    belongs_to :autor, User, on_replace: :update

    many_to_many :tags, Tag,
      join_through: "midias_tags",
      on_replace: :delete,
      unique: true

    timestamps()
  end

  @spec changeset(map, list(struct)) :: Result.t(Midia.t(), changeset)
  def changeset(midia \\ %__MODULE__{}, attrs, tags) do
    midia
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:link)
    |> unique_constraint(:nome_arquivo)
    |> foreign_key_constraint(:autor_id)
    |> put_assoc(:tags, tags)
    |> put_change(:id_publico, Nanoid.generate())
    |> apply_action(:parse)
  end

  def tipos, do: @tipos
end
