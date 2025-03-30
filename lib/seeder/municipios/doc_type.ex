defmodule Seeder.DocumentTypeSeeder do
  alias Pescarte.Municipios.DocumentType

  def entries do
    [
      %DocumentType{name: "EVTEAS Conceitual"},
      %DocumentType{name: "Atualização EVTEAS"},
      %DocumentType{name: "Plano de Riscos"},
      %DocumentType{name: "Cercamento do terreno por parte da Petrobras"},
      %DocumentType{name: "Instalação de placa por parte da Petrobras"},
      %DocumentType{name: "Projeto conceitual"},
      %DocumentType{name: "Projeto Básico"},
      %DocumentType{name: "Assinatura do contrato"}
    ]
  end
end
