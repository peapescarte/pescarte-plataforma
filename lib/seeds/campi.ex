defmodule Seeds.Campi do
  alias Pescarte.Database
  alias Pescarte.Domains.ModuloPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Campus

  def run do
    IO.puts("==> Running Campi seeds")

    Enum.each(campi(), &insert/1)
  end

  defp insert(attrs) do
    case ModuloPesquisa.get_campus(initials: attrs.initials) do
      {:ok, _cidade} ->
        IO.puts("==> Campus with initials #{attrs.initials} already exists")

      _ ->
        Campus
        |> struct!(attrs)
        |> Database.insert!()
    end
  end

  defp campi do
    [
      %{
        name: "Universidade Estadual do Norte Fluminense Darcy Ribeiro",
        initials: "UENF",
        cidade_id: ModuloPesquisa.get_cidade(county: "Campos dos Goytacazes").id,
        public_id: Nanoid.generate()
      },
      %{
        name: "Universidade Federal de São Carlos",
        initials: "UFSCar",
        cidade_id: ModuloPesquisa.get_cidade(county: "Sorocaba").id,
        public_id: Nanoid.generate()
      }
    ]
  end
end
