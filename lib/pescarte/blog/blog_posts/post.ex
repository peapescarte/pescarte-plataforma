defmodule Pescarte.Blog.BlogPosts.Post do

  alias Pescarte.Identidades.Models.Usuario
  alias Pescarte.Database.Types.PublicId
  use Pescarte, :model

@required_params [:titulo, :conteudo, :link_imagem_capa, :published_at]

  @primary_key {:id, PublicId, autogenerate: true}
  schema "post" do
    field :titulo, :string
    field :conteudo, :binary
    field :link_imagem_capa, :string
    field :published_at, :naive_datetime

    belongs_to :usuario, Usuario

    timestamps()
  end

  def changeset(post \\%Post{}, params) do
    post
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end

end
