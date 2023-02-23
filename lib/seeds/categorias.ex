defmodule Seeds.Categorias do
  alias Pescarte.Database
  alias Pescarte.Domains.ModuloPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria

  def run do
    IO.puts("==> Running Midia Categorias seeds")

    Enum.each(categorias(), &insert/1)
  end

  defp insert(attrs) do
    case ModuloPesquisa.get_categoria(name: attrs.name) do
      {:ok, _cidade} ->
        IO.puts("==> Categoria with name #{attrs.name} already exists")

      _ ->
        Categoria
        |> struct!(attrs)
        |> Database.insert!()
    end
  end

  defp categorias do
    [
      %{name: "autoral", public_id: Nanoid.generate()},
      %{name: "local", public_id: Nanoid.generate()},
      %{name: "conteudo", public_id: Nanoid.generate()},
      %{name: "eventos", public_id: Nanoid.generate()}
    ]
  end
end
