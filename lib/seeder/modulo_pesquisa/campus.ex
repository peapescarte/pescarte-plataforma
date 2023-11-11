defmodule Seeder.ModuloPesquisa.Campus do
  alias Pescarte.ModuloPesquisa.Models.Campus
  @behaviour Seeder.Entry

  @impl true
  def entries do
    [
      %Campus{
        acronimo: "UENF",
        nome: "Universidade Estadual do Norte Fluminense Darcy Ribeiro",
        endereco_cep: "28013602",
        id_publico: Nanoid.generate_non_secure()
      },
      %Campus{
        acronimo: "UFSCar",
        nome: "Universidade Federal de São Carlos",
        endereco_cep: "13565905",
        id_publico: Nanoid.generate_non_secure()
      }
    ]
  end
end
