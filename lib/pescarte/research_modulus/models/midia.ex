defmodule Backend.ResearchModulus.Models.Midia do
  use Backend, :model

  alias Backend.ResearchModulus.Models.Researcher
  alias Backend.Types.TrimmedString

  @midia_types ~w(video imagem documento)a

  schema "midia" do
    field :type, Ecto.Enum, values: @midia_types
    field :link, TrimmedString
    field :public_id, :string

    belongs_to :researcher, Researcher, on_replace: :update

    timestamps()
  end
end
