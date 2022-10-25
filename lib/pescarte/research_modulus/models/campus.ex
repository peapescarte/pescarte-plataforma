defmodule Pescarte.ResearchModulus.Models.Campus do
  use Pescarte, :model

  alias Pescarte.ResearchModulus.Models.City
  alias Pescarte.ResearchModulus.Models.Researcher
  alias Pescarte.Types.TrimmedString

  schema "campus" do
    field :name, TrimmedString
    field :initials, TrimmedString
    field :public_id, :string

    has_many :researchers, Researcher
    belongs_to :city, City, on_replace: :delete

    timestamps()
  end
end
