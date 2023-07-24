defmodule Cotacoes.Models.Fonte do
  use Database, :model

  @type t :: %Fonte{id: binary, nome: binary, link: binary, descricao: binary}

  @required_fields ~w(nome link)a
  @optional_fields ~w(descricao)a

  @primary_key {:nome, :string, autogenerate: false}
  schema "fonte_cotacao" do
    field :link, :string
    field :descricao, :string
    field :id, Database.Types.PublicId, autogenerate: true
  end

  @spec changeset(Fonte.t(), map) :: changeset
  def changeset(%Fonte{} = fonte, attrs) do
    fonte
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:nome, name: :fonte_cotacao_pkey)
  end
end
