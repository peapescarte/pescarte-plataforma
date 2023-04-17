defmodule Seeds.Tags do
  alias Pescarte.Database
  alias Pescarte.Domains.ModuloPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag

  def run do
    IO.puts("==> Running Midia Tags seeds")

    Enum.each(tags(), &insert/1)
  end

  defp insert(attrs) do
    case ModuloPesquisa.get_tag(label: attrs.label) do
      {:ok, _cidade} ->
        IO.puts("==> Tag with label #{attrs.label} already exists")

      _ ->
        Tag
        |> struct!(attrs)
        |> Database.insert!()
    end
  end

  defp tags do
    conteudo_id = ModuloPesquisa.get_categoria(name: "conteudo").id
    autoral_id = ModuloPesquisa.get_categoria(name: "autoral").id

    [
      %{
        label: "fulano_da_silva",
        categoria_id: autoral_id,
        public_id: Nanoid.generate()
      },
      %{
        label: "redes",
        categoria_id: conteudo_id,
        public_id: Nanoid.generate()
      },
      %{
        label: "peixes",
        categoria_id: conteudo_id,
        public_id: Nanoid.generate()
      },
      %{
        label: "mar",
        categoria_id: conteudo_id,
        public_id: Nanoid.generate()
      },
      %{
        label: "barco",
        categoria_id: conteudo_id,
        public_id: Nanoid.generate()
      }
    ]
  end
end
