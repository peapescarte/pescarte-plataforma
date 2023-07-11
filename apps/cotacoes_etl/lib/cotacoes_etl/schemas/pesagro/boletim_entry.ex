defmodule CotacoesETL.Schemas.Pesagro.BoletimEntry do
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  @typep tipo :: :pdf | :zip
  @type t :: %BoletimEntry{link: binary, arquivo: binary, tipo: tipo}

  @fields ~w(link arquivo tipo)a

  @primary_key false
  embedded_schema do
    field(:link, :string)
    field(:arquivo, :string)
    field(:tipo, Ecto.Enum, values: ~w(pdf zip)a)
  end

  @spec changeset(map) :: BoletimEntry.t()
  def changeset(attrs) do
    %BoletimEntry{}
    |> cast(attrs, @fields)
    |> validate_required(@fields)
    |> apply_action!(:parse)
  end
end
