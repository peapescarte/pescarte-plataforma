defmodule Fuschia.Accounts.Models.ContatoModel do
  @moduledoc """
  Contato schema
  """

  use Fuschia.Schema

  import Ecto.Changeset

  alias Fuschia.Accounts.Logic.ContatoLogic
  alias Fuschia.Common.Formats

  @required_fields ~w(email endereco celular)a

  @mobile_format Formats.mobile()

  schema "contato" do
    field :celular, :string
    field :email, :string
    field :endereco, :string

    timestamps()
  end

  @doc false
  @spec changeset(%__MODULE__{}, map) :: Ecto.Changeset.t()
  def changeset(contato, attrs) do
    contato
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_format(:celular, @mobile_format)
    |> ContatoLogic.validate_email()
  end

  defimpl Jason.Encoder, for: __MODULE__ do
    alias Fuschia.Accounts.Adapters.ContatoAdapter

    @spec encode(Contato.t(), map) :: map
    def encode(struct, opts) do
      struct
      |> ContatoAdapter.to_map()
      |> Fuschia.Encoder.encode(opts)
    end
  end
end
