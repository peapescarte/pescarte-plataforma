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
        endereco_id: "zMz_K9TlJ0Uk7Wk-E41bF",
        id: Nanoid.generate_non_secure()
      },
      %Campus{
        acronimo: "UFSCar",
        nome: "Sorocaba",
        nome_universidade: "Universidade Federal de São Carlos",
        endereco_id: "qbGuOuaCvD5JNBpexdIL4",
        id: Nanoid.generate_non_secure()
      }
    ]
  end
end
