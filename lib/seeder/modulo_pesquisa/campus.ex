defmodule Seeder.ModuloPesquisa.Campus do
  alias Pescarte.ModuloPesquisa.Models.Campus
  @behaviour Seeder.Entry

  @impl true
  def entries do
    [
      %Campus{
        acronimo: "UENF",
        nome: "Campos dos Goytacazes",
        nome_universidade: "Universidade Estadual do Norte Fluminense Darcy Ribeiro",
        endereco: Faker.Address.street_address(true)
      },
      %Campus{
        acronimo: "UFSCar",
        nome: "Sorocaba",
        nome_universidade: "Universidade Federal de São Carlos",
        endereco: Faker.Address.street_address(true)
      }
    ]
  end
end
