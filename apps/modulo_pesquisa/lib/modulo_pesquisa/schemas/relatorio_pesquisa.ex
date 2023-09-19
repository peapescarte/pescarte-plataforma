defmodule ModuloPesquisa.Schemas.RelatorioPesquisa do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  @type t :: %RelatorioPesquisa{
          tipo: atom,
          conteudo: map,
          inicio_periodo: Date.t(),
          fim_periodo: Date.t(),
          link: binary,
          status: atom
        }

  @tipo ~w(mensal bimestral trimestral anual)a
  @status ~w(entregue atrasado pendente)a

  @required_fields ~w(tipo conteudo inicio_periodo fim_periodo status)a
  @optional_fields ~w(link)a

  @primary_key false
  embedded_schema do
    field :tipo, Ecto.Enum, values: @tipo
    field :conteudo, :map
    field :inicio_periodo, :date
    field :fim_periodo, :date
    field :link, :string
    field :status, Ecto.Enum, values: @status
  end

  def parse!(attrs) do
    %RelatorioPesquisa{}
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> apply_action!(:parse)
  end
end
