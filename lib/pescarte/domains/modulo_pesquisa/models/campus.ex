defmodule Pescarte.Domains.ModuloPesquisa.Models.Campus do
  use Pescarte, :model

  alias Pescarte.Domains.ModuloPesquisa.Models.Cidade
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.Types.TrimmedString

  @required_fields ~w(initials cidade_id)a
  @optional_fields ~w(name)a

  schema "campus" do
    field :name, TrimmedString
    field :initials, TrimmedString
    field :public_id, :string

    has_many :pesquisadors, Pesquisador
    belongs_to :cidade, Cidade, on_replace: :delete

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
    |> unique_constraint(:initials)
    |> foreign_key_constraint(:cidade_id)
    |> put_change(:public_id, Nanoid.generate())
    |> apply_action(:parse)
  end

  def list_campus_by_county_query(county) do
    from c in __MODULE__, where: c.county == ^county
  end
end
