defmodule Fuschia.PesquisadorTables.Nucleo do
  @moduledoc """
  Esquema que representa um nucleo de Pesquisa no BD
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:nome, :string, []}
  schema "nucleo" do
    field :descricao_nucleo, :string

    timestamps()
  end

  @doc false
  def changeset(nucleo, attrs) do
    nucleo
    |> cast(attrs, [:nome, :descricao_nucleo])
    |> validate_required([:nome, :descricao_nucleo])
    |> validate_length(:descricao_nucleo, max: 400)
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    def encode(struct, opts) do
      %{
        nome: struct.nome,
        descricao_nucleo: struct.descricao_nucleo
      }
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
