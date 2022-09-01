defmodule Fuschia.ResearchModulus.Models.Campus do
  use Fuschia, :model

  alias Fuschia.ResearchModulus.Models.City
  alias Fuschia.ResearchModulus.Models.Researcher
  alias Fuschia.Types.TrimmedString

  schema "campus" do
    field :name, TrimmedString
    field :initials, TrimmedString
    field :public_id, :string

    has_many :researchers, Researcher
    belongs_to :city, City, on_replace: :delete

    timestamps()
  end
end
