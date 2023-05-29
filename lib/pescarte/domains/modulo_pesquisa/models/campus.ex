defmodule Pescarte.Domains.ModuloPesquisa.Models.Campus do
  use Pescarte, :model

  alias Pescarte.Domains.Accounts.Models.Endereco
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.Types.TrimmedString

  @required_fields ~w(acronimo endereco_id)a
  @optional_fields ~w(nome)a

  schema "campus" do
    field :nome, TrimmedString
    field :acronimo, TrimmedString
    field :id_publico, :string

    has_many :pesquisadores, Pesquisador
    belongs_to :endereco, Endereco, on_replace: :delete

    timestamps()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:nome)
    |> unique_constraint(:acronimo)
    |> validate_change(:acronimo, fn f, v ->
      v == String.upcase(v) && [] || [{f, "não está em caixa alta"}]
    end)
    |> foreign_key_constraint(:endereco_id)
    |> put_change(:id_publico, Nanoid.generate())
  end

  def list_campus_by_county_query(county) do
    from c in __MODULE__, where: c.county == ^county
  end
end
