defmodule Fuschia.ResearchModulus.Models.Midia do
  use Fuschia, :model

  alias Fuschia.ResearchModulus.Models.Researcher
  alias Fuschia.Types.TrimmedString

  @midia_types ~w(video imagem documento)a

  schema "midia" do
    field :type, Ecto.Enum, values: @midia_types
    field :link, TrimmedString

    belongs_to :researcher, Researcher, on_replace: :update

    timestamps()
  end
end
