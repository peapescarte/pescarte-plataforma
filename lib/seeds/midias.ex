defmodule Seeds.Midias do
  alias Pescarte.Database
  alias Pescarte.Domains.ModuloPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia

  def run do
    IO.puts("==> Running Midia seeds")

    Enum.each(midias(), &insert/1)
  end

  defp insert(attrs) do
    case ModuloPesquisa.get_midia(filename: attrs.filename) do
      {:ok, _cidade} ->
        IO.puts("==> Midia with filename #{attrs.filename} already exists")

      _ ->
        Midia
        |> struct!(attrs)
        |> Database.insert!()
    end
  end

  defp midias do
    {:ok, categoria} = ModuloPesquisa.get_categoria(name: "conteudo")
    tags = ModuloPesquisa.list_tags_by(categoria)

    author_id =
      elem(ModuloPesquisa.get_pesquisador(link_lattes: "https://github.com/zoedsoupe"), 1).id

    [
      %{
        tags: tags,
        public_id: Nanoid.generate(),
        filename: "IMG20230126.png",
        type: :imagem,
        filedate: Date.utc_today(),
        author_id: author_id,
        link: "https://drive.google.com/uc?export=view&id=1YqVklE01-XPX-6iAO0iYie5acOCk0rhk"
      },
      %{
        tags: tags,
        public_id: Nanoid.generate(),
        filename: "IMG2023014.png",
        type: :imagem,
        filedate: Date.utc_today(),
        author_id: author_id,
        link: "https://drive.google.com/uc?export=view&id=1SqVklE01-XPX-6iAO0iYie5acOCk0rhk"
      }
    ]
  end
end
