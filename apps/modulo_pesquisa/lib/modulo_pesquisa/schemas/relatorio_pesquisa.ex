defmodule ModuloPesquisa.Schemas.RelatorioPesquisa do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__
  alias ModuloPesquisa.Schemas.Conteudo

  @type t :: %RelatorioPesquisa{
          tipo: atom,
          conteudo: map,
          data_inicio: Date.t(),
          data_fim: Date.t(),
          data_entrega: Date.t(),
          data_limite: Date.t(),
          link: binary,
          status: atom
        }

  @tipo ~w(mensal bimestral trimestral anual)a
  @status ~w(entregue atrasado pendente)a

  @required_fields ~w(tipo data_inicio data_fim data_limite status)a
  @optional_fields ~w(data_entrega link)a

  @primary_key false

  embedded_schema do
    field :tipo, Ecto.Enum, values: @tipo
    field :data_inicio, :date
    field :data_fim, :date
    field :data_entrega, :date
    field :data_limite, :date
    field :link, :string
    field :status, Ecto.Enum, values: @status

    embeds_one :conteudo, Conteudo, on_replace: :update
  end

  def parse!(attrs) do
    %RelatorioPesquisa{}
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_embed(:conteudo)
    |> validate_required(@required_fields)
    |> apply_action!(:parse)
  end
end
