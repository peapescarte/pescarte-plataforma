defmodule Pescarte.ModuloPesquisa.Schemas.Celetista do
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  @type t :: %Celetista{
          id: String.t(),
          nome: String.t(),
          cpf: String.t(),
          email: String.t(),
          equipe: String.t()
        }

  @required_fields ~w(id nome equipe)a

  @primary_key false
  embedded_schema do
    field :id, Pescarte.Database.Types.PublicId, autogenerate: false
    field :nome, :string
    field :cpf, :string
    field :email, :string
    field :equipe, :string
  end

  def parse!(attrs) do
    %Celetista{}
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> apply_action!(:parse)
  end
end
