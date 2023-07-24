defmodule PlataformaDigitalAPI.Type.Midia do
  use Absinthe.Schema.Notation

  alias PlataformaDigitalAPI.Resolver

  @desc "Tipos possíveis de Midias"
  enum :tipo_midia_enum do
    value(:imagem)
    value(:documento)
    value(:video)
  end

  @desc "Representa uma Mídia genérica da plataforma"
  object :midia do
    field(:nome_arquivo, :string)
    field(:data_arquivo, :date)
    field(:link, :string)
    field(:restrito?, :boolean, name: "restrito")
    field(:tipo, :tipo_midia_enum)
    field(:observacao, :string)
    field(:texto_alternativo, :string)
    field(:id_publico, :string, name: "id")

    field :autor, :usuario do
      resolve(&Resolver.User.get_by_midia/3)
    end

    field :tags, list_of(:tag) do
      resolve(&Resolver.Tag.list_midias/3)
    end
  end
end
