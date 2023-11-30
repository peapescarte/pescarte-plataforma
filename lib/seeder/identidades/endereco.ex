defmodule Seeder.Identidades.Endereco do
  alias Pescarte.Identidades.Models.Endereco

  @behaviour Seeder.Entry

  @impl true
  def entries do
    [
      %Endereco{
        cep: "28013602",
        cidade: "Campos dos Goytacazes",
        estado: "Rio de Janeiro",
        numero: "2000",
        rua: "Avenida Alberto Lamego",
        id_publico: Nanoid.generate_non_secure()
      },
      %Endereco{
        cep: "13565905",
        cidade: "São Carlos",
        estado: "São Paulo",
        rua: "Rod. Washington Luís",
        id_publico: Nanoid.generate_non_secure()
      }
    ]
  end
end
