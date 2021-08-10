defmodule Fuschia.Entities.Nucleo do
  @moduledoc """
  Nucleo schema
  """
  use Fuschia.Schema
  import Ecto.Changeset

  alias Fuschia.Entities.LinhaPesquisa
  alias Fuschia.Types.CapitalizedString

  @required_fields ~w(nome descricao)a

  @primary_key {:nome, CapitalizedString, []}
  schema "nucleo" do
    field :descricao, :string

    has_many :linhas_pesquisa, LinhaPesquisa

    timestamps()
  end

  @doc false
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:descricao, max: 400)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, opts) do
      %{
        nome: struct.nome,
        descricao: struct.descricao,
        linhas_pesquisa: struct.linhas_pesquisa
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
