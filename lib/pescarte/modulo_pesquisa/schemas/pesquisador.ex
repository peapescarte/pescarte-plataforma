defmodule Pescarte.ModuloPesquisa.Schemas.Pesquisador do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__
  alias Pescarte.ModuloPesquisa.Models.Pesquisador, as: Model

  @type t :: %Pesquisador{
          id: String.t(),
          nome: String.t(),
          cpf: String.t(),
          email: String.t(),
          participacao: String.t()
        }

  @required_fields ~w(id nome cpf email participacao)a

  @primary_key false
  embedded_schema do
    field(:id, Pescarte.Database.Types.PublicId, autogenerate: false)
    field(:nome, :string)
    field(:cpf, :string)
    field(:email, :string)
    field(:participacao, Ecto.Enum, values: Model.tipo_bolsas())
  end

  def parse!(attrs) do
    %Pesquisador{}
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> apply_action!(:parse)
  end
end
