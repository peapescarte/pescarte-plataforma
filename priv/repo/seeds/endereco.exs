defmodule EnderecoSeed do
  alias Pescarte.Domains.Accounts.Models.Endereco

  def entries do
    [
      %Endereco{
        cep: "28013602",
        cidade: "Campos dos Goytacazes",
        estado: "Rio de Janeiro",
        numero: "2000",
        rua: "Avenida Alberto Lamego"
      },
      %Endereco{
        cep: "13565905",
        cidade: "São Carlos",
        estado: "São Paulo",
        rua: "Rod. Washington Luís"
      }
    ]
  end
end
