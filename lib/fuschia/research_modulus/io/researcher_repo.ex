defmodule Fuschia.ResearchModulus.IO.ResearcherRepo do
  use Fuschia, :repo

  alias Fuschia.ResearchModulus.Models.Researcher

  @required_fields ~w(
    minibio
    bursary
    link_lattes
    campus_id
    user_id
  )a

  @optional_fields ~w(advisor_id)a

  @update_fields ~w(minibio bursary link_lattes)a

  def changeset(%Researcher{} = researcher, attrs \\ %{}) do
    researcher
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
    |> validate_length(:minibio, max: 280)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:advisor_id)
    |> foreign_key_constraint(:campus_id)
    |> put_change(:public_id, Nanoid.generate())
  end

  @impl true
  def all do
    Researcher
    |> Database.all()
    |> Database.preload(user: [:contact])
  end   

  @impl true
  def fetch(id) do
    fetch(Researcher, id)
  end

  @impl true
  def insert(attrs) do
    %Researcher{}
    |> changeset(attrs)
    |> Database.insert()
  end

  @impl true
  def update(%Researcher{} = researcher, attrs) do
    researcher
    |> cast(attrs, @update_fields)
    |> validate_length(:minibio, max: 280)
    |> Database.update()
  end
end
