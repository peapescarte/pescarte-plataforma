defmodule Pescarte.Blog.Entity.Tag do
  use Pescarte, :model

  alias Pescarte.Database.Types.PublicId

  @type t :: %Tag{nome: binary, id: binary}

  @required_fields ~w(nome)a

  @primary_key {:id, PublicId, autogenerate: true}
  schema "blog_tag" do
    field :nome, :string

    timestamps()
  end

  @spec changeset(Tag.t(), map) :: changeset
  def changeset(%Tag{} = tag, attrs) do
    tag
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:nome)
  end
end
