defmodule Cotacoes.Models.Cotacao do
  use Database, :model

  @typep tipo_cotacao :: :pdf | :zip

  @type t :: %Cotacao{
          id: binary,
          data: Date.t(),
          link: binary,
          fonte: binary,
          importada?: boolean,
          baixada?: boolean,
          tipo: tipo_cotacao
        }

  @required_fields ~w(data fonte tipo)a
  @optional_fields ~w(link importada? baixada?)a

  @primary_key false
  schema "cotacao" do
    field :data, :date, primary_key: true
    field :link, :string, primary_key: true
    field :fonte, :string
    field :importada?, :boolean, default: false
    field :baixada?, :boolean, default: false
    field :tipo, Ecto.Enum, values: ~w(pdf zip)a
    field :id, Database.Types.PublicId, autogenerate: true
  end

  @spec changeset(Cotacao.t(), map) :: changeset
  def changeset(%Cotacao{} = cotacao, attrs) do
    cotacao
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:fonte)
    |> unique_constraint(:data, name: :cotacao_pkey)
    |> unique_constraint(:link, name: :cotacao_pkey)
    |> unique_constraint(:data, name: :cotacao_data_link_index)
    |> unique_constraint(:link, name: :cotacao_data_link_index)
  end
end
