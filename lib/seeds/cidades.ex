defmodule Seeds.Cidades do
  alias Pescarte.Database
  alias Pescarte.Domains.ModuloPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Cidade

  def run do
    IO.puts("==> Running Cidades seeds")

    Enum.each(cidades(), &insert/1)
  end

  defp insert(attrs) do
    case ModuloPesquisa.get_cidade(county: attrs.county) do
      {:ok, _cidade} ->
        IO.puts("==> Cidade with county #{attrs.county} already exists")

      _ ->
        Cidade
        |> struct!(attrs)
        |> Database.insert!()
    end
  end

  defp cidades do
    [
      %{county: "Campos Dos Goytacazes", public_id: Nanoid.generate()},
      %{county: "Sorocaba", public_id: Nanoid.generate()}
    ]
  end
end
