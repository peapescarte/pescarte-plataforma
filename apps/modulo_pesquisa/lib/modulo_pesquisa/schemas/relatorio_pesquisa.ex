defmodule ModuloPesquisa.Schemas.RelatorioPesquisa do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  @type t :: %RelatorioPesquisa{
          data: Date.t(),
          periodo: String.t(),
          nome_pesquisador: String.t(),
          tipo: atom,
          status: atom
        }

  @required_fields ~w(periodo tipo status)a
  @optional_fields ~w(data nome_pesquisador)a

  embedded_schema do
    field :data, :date
    field :periodo, :string
    field :nome_pesquisador, :string
    field :tipo, Ecto.Enum, values: ~w(anual mensal trimestral)a
    field :status, Ecto.Enum, values: ~w(entregue pendente atrasado)a
  end

  @spec parse!(map) :: RelatorioPesquisa.t()
  def parse!(attrs) do
    %RelatorioPesquisa{}
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> apply_action!(:parse)
  end
end
