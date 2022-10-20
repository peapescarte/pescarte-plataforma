defmodule Pescarte.ResearchModulus.Models.Midia do
  use Pescarte, :model

  alias Pescarte.ResearchModulus.Models.Researcher
  alias Pescarte.Types.TrimmedString

  @midia_types ~w(video imagem documento)a

  schema "midia" do
    field :type, Ecto.Enum, values: @midia_types
    field :link, TrimmedString
    field :public_id, :string

    belongs_to :researcher, Researcher, on_replace: :update

    timestamps()
  end
end
