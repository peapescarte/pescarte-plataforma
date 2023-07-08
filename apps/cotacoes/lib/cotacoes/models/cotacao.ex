defmodule Cotacoes.Models.Cotacao do
  use Database, :model

  @type t :: %Cotacao{
          id: binary,
          data: Date.t(),
          link: binary,
          fonte: binary,
          importada?: boolean,
          baixada?: boolean
        }

  @required_fields ~w(data fonte)a
  @optional_fields ~w(link importada? baixada?)a

  @primary_key {:link, :string, autogenerate: false}
  schema "cotacao" do
    field :data, :date
    field :fonte, :string
    field :importada?, :boolean, default: false
    field :baixada?, :boolean, default: false
    field :id, Database.Types.PublicId, autogenerate: true
  end

  @spec changeset(Cotacao.t(), map) :: changeset
  def changeset(%Cotacao{} = cotacao, attrs) do
    cotacao
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:fonte)
    |> unique_constraint(:data)
  end
end
