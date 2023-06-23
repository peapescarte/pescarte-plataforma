defmodule CampusSeed do
  alias Pescarte.Domains.ModuloPesquisa.Models.Campus

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
