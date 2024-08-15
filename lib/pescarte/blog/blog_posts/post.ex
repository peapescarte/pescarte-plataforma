defmodule Pescarte.Blog.BlogPosts.Post do
  alias Pescarte.Database.Types.PublicId
  alias Pescarte.Identidades.Models.Usuario
  use Pescarte, :model

  @doc """
  Módulo que define o schema e o changeset para os posts.
  """

  @type t :: %Post{
          id: String.t(),
          titulo: String.t(),
          conteudo: String.t(),
          link_imagem_capa: String.t(),
          published_at: NaiveDateTime.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t(),
          usuario: Usuario.t(),
          usuario_id: String.t()
        }

  @required_params [:titulo, :conteudo, :link_imagem_capa, :published_at]

  @primary_key {:id, PublicId, autogenerate: true}
  schema "posts" do
    field :titulo, :string
    field :conteudo, :binary
    field :link_imagem_capa, :string
    field :published_at, :naive_datetime

    belongs_to :usuario, Usuario

    # comentado enquanto o PR das tags não é aprovado
    # has_many :tags, Tag, through: [:post_tags, :tag]

    timestamps()
  end

  def changeset(post \\ %Post{}, params) do
    post
    |> cast(params, @required_params)
    |> validate_required(@required_params)
  end
end
