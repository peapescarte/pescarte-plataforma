defmodule Pescarte.Cotacoes.Models.Cotacao do
  use Pescarte, :model

  alias Pescarte.Cotacoes.Models.Fonte
  alias Pescarte.Database.Types.PublicId

  @typep tipo_cotacao :: :pdf | :zip

  @type t :: %Cotacao{
          id: binary,
          data: Date.t(),
          link: binary,
          fonte: Fonte.t(),
          importada?: boolean,
          baixada?: boolean,
          tipo: tipo_cotacao
        }

  @required_fields ~w(data fonte_id tipo link)a
  @optional_fields ~w(importada? baixada?)a

  @primary_key {:id, PublicId, autogenerate: true}
  schema "cotacao" do
    field :data, :date, primary_key: true
    field :link, :string, primary_key: true
    field :importada?, :boolean, default: false
    field :baixada?, :boolean, default: false
    field :tipo, Ecto.Enum, values: ~w(pdf zip)a

    belongs_to :fonte, Fonte, type: :string

    timestamps()
  end

  @spec changeset(Cotacao.t(), map) :: changeset
  def changeset(%Cotacao{} = cotacao, attrs) do
    cotacao
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:fonte_id)
  end
end
