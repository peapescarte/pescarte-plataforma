defmodule Pescarte.Domains.ModuloPesquisa.Models.Midia do
  use Pescarte, :model

  alias Pescarte.Domains.Accounts.Models.User
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag
  alias Pescarte.Types.TrimmedString

  @required_fields ~w(type filename filedate sensible? link author_id)a
  @optional_fields ~w(observation alt_text)a
  @update_fields ~w(type link filename filedate observation alt_text)a

  @types ~w(imagem video documento)a

  schema "midia" do
    field :type, Ecto.Enum, values: @types
    field :filename, TrimmedString
    field :filedate, :date
    field :sensible?, :boolean, default: false
    field :observation, TrimmedString
    field :link, TrimmedString
    field :alt_text, TrimmedString
    field :id_publico, :string

    belongs_to :author, User, on_replace: :update

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
    |> foreign_key_constraint(:author_id)
    |> put_assoc(:tags, tags)
    |> put_change(:id_publico, Nanoid.generate())
    |> apply_action(:parse)
  end

  def update_changeset(midia, attrs) do
    midia
    |> cast(attrs, @update_fields)
    |> unique_constraint(:filename)
    |> unique_constraint(:link)
    |> put_assoc(:tags, attrs[:tags] || midia.tags)
    |> apply_action(:parse)
  end

  def list_tags_query(%__MODULE__{} = midia) do
    from m in __MODULE__, where: m.id == ^midia.id, preload: :tags
  end

  def types, do: @types
end
