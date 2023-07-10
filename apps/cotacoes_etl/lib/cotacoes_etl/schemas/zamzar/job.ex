defmodule CotacoesETL.Schemas.Zamzar.Job do
  use Ecto.Schema
  import Ecto.Changeset
  alias CotacoesETL.Schemas.Zamzar.File
  alias __MODULE__

  @type t :: %Job{
          id: integer,
          sandbox: boolean,
          key: String.t(),
          created_at: NaiveDateTime.t(),
          finished_at: NaiveDateTime.t(),
          target_format: String.t(),
          status: atom,
          source_file: File.t(),
          target_files: list(File.t())
        }

  @fields ~w(id sandbox key created_at finished_at target_format credit_cost status)a
  @status ~w(initialising successful failed converting)a

  @primary_key false
  embedded_schema do
    field(:id, :integer)
    field(:sandbox, :boolean)
    field(:key, :string)
    field(:created_at, :naive_datetime)
    field(:finished_at, :naive_datetime)
    field(:target_format, :string)
    field(:credit_cost, :integer)
    field(:status, Ecto.Enum, values: @status)

    embeds_one(:source_file, File)
    embeds_many(:target_files, File)
  end

  def changeset(attrs) do
    %Job{}
    |> cast(attrs, @fields)
    |> cast_embed(:source_file, with: &File.changeset/2, required: true)
    |> cast_embed(:target_files, with: &File.changeset/2, required: false)
    |> apply_action!(:parse)
  end
end
