defmodule CotacoesETL.Schemas.Zamzar.File do
  use Ecto.Schema
  import Ecto.Changeset
  alias __MODULE__

  @type t :: %File{
          id: integer,
          key: String.t(),
          size: integer,
          name: String.t(),
          path: Path.t(),
          format: String.t(),
          created_at: NaiveDateTime.t()
        }

  @fields ~w(id key size name format created_at)a

  @primary_key false
  embedded_schema do
    field(:id, :integer)
    field(:key, :string)
    field(:size, :integer)
    field(:name, :string)
    field(:path, :string)
    field(:format, :string)
    field(:created_at, :naive_datetime)
  end

  def changeset(file \\ %File{}, attrs) do
    file
    |> cast(attrs, @fields)
    |> apply_action!(:parse)
  end
end
