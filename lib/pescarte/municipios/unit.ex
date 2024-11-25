defmodule Pescarte.Municipios.Unit do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @tipo_status ~w(
    Concluído
    Pendente
    Em andamento
  )a
  schema "units" do
    field :name, :string
    field :status, Ecto.Enum, values: @tipo_status
    field :situation, :string
    field :next_step, :string
    field :document_link, :string
    field :created_by, :binary_id
    field :updated_by, :binary_id

    belongs_to :municipio, Pescarte.Municipios.Municipio, type: :binary_id

    timestamps()
  end

  @doc false
  def changeset(unit, attrs) do
    unit
    |> cast(attrs, [
      :municipio_id,
      :name,
      :status,
      :next_step,
      :document_link,
      :created_by,
      :updated_by
    ])
    |> validate_required([:municipio_id, :name, :created_by, :updated_by])
    |> validate_format(:document_link, ~r/^https?:\/\/\S+$/, message: "deve ser uma URL válida")
    |> assoc_constraint(:municipio)
  end
end
