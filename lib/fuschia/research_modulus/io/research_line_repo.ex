defmodule Fuschia.ResearchModulus.IO.ResearchLineRepo do
  use Fuschia, :repo

  alias Fuschia.ResearchModulus.Models.ResearchLine

  @required_fields ~w(research_core_id sort_desc number)a
  @optional_fields ~w(desc)a

  @impl true
  def all do
    Database.all(ResearchLine)
  end

  @impl true
  def fetch(id) do
    fetch(ResearchLine, id)
  end

  @impl true
  def insert(%ResearchLine{} = line) do
    line
    |> cast(%{}, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:short_desc, max: 90)
    |> validate_length(:desc, max: 280)
    |> foreign_key_constraint(:research_core_id)
    |> put_change(:public_id, Nanoid.generate())
    |> Database.insert()
  end

  def list_research_line_by_research_core(core_id) do
    query =
      from l in ResearchLine,
        inner_join: n in assoc(l, :research_core),
        where: n.id == ^core_id

    Database.all(query)
  end
end
