defmodule Backend.ResearchModulus.Models.Campus do
  use Backend, :model

  alias Backend.ResearchModulus.Models.City
  alias Backend.ResearchModulus.Models.Researcher
  alias Backend.Types.TrimmedString

  schema "campus" do
    field :name, TrimmedString
    field :initials, TrimmedString
    field :public_id, :string

    has_many :researchers, Researcher
    belongs_to :city, City, on_replace: :delete

    timestamps()
  end
end
