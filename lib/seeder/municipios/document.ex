defmodule Seeder.DocumentSeeder do
  alias Pescarte.Municipios.Document

  def entries(municipios, units, document_types) do
    documents_data = [
      # Armação dos Búzios - UPP - Unidade de Processamento de Pescado
      %{
        municipio: "Armação dos Búzios",
        unidade: "UPP - Unidade de Processamento de Pescado",
        document_type: "EVTEAS Conceitual",
        status: :em_andamento,
        document_link: "https://example.com/document1.pdf"
      },
      %{
        municipio: "Armação dos Búzios",
        unidade: "UPP - Unidade de Processamento de Pescado",
        document_type: "Atualização EVTEAS",
        status: :pendente,
        document_link: "https://example.com/document2.pdf"
      },
      %{
        municipio: "Armação dos Búzios",
        unidade: "UPP - Unidade de Processamento de Pescado",
        document_type: "Plano de Riscos",
        status: :pendente,
        document_link: "https://example.com/document3.pdf"
      },

      # Armação dos Búzios - UPM - Unidade de Produção de Moluscos 3
      %{
        municipio: "Armação dos Búzios",
        unidade: "UPM - Unidade de Produção de Moluscos 3",
        document_type: "EVTEAS Conceitual",
        status: :concluido,
        document_link: "https://example.com/document4.pdf"
      },
      %{
        municipio: "Armação dos Búzios",
        unidade: "UPM - Unidade de Produção de Moluscos 3",
        document_type: "Atualização EVTEAS",
        status: :em_andamento,
        document_link: "https://example.com/document5.pdf"
      },
      %{
        municipio: "Armação dos Búzios",
        unidade: "UPM - Unidade de Produção de Moluscos 3",
        document_type: "Plano de Riscos",
        status: :pendente,
        document_link: "https://example.com/document6.pdf"
      },

      # Armação dos Búzios - Unidade de Produção de sementes
      %{
        municipio: "Armação dos Búzios",
        unidade: "Unidade de Produção de sementes",
        document_type: "EVTEAS Conceitual",
        status: :pendente,
        document_link: "https://example.com/document7.pdf"
      },
      %{
        municipio: "Armação dos Búzios",
        unidade: "Unidade de Produção de sementes",
        document_type: "Atualização EVTEAS",
        status: :pendente,
        document_link: "https://example.com/document8.pdf"
      },

      # Arraial do Cabo - Unidade de Beneficiamento de Moluscos
      %{
        municipio: "Arraial do Cabo",
        unidade: "Unidade de Beneficiamento de Moluscos",
        document_type: "EVTEAS Conceitual",
        status: :em_andamento,
        document_link: "https://example.com/document9.pdf"
      },
      %{
        municipio: "Arraial do Cabo",
        unidade: "Unidade de Beneficiamento de Moluscos",
        document_type: "Atualização EVTEAS",
        status: :pendente,
        document_link: "https://example.com/document10.pdf"
      },

      # Arraial do Cabo - UPP - Unidade de Processamento de Pescado
      %{
        municipio: "Arraial do Cabo",
        unidade: "UPP - Unidade de Processamento de Pescado",
        document_type: "EVTEAS Conceitual",
        status: :em_andamento,
        document_link: "https://example.com/document11.pdf"
      },
      %{
        municipio: "Arraial do Cabo",
        unidade: "UPP - Unidade de Processamento de Pescado",
        document_type: "Atualização EVTEAS",
        status: :pendente,
        document_link: "https://example.com/document12.pdf"
      },

      # Arraial do Cabo - UPA - Unidade de Produção Aquícola
      %{
        municipio: "Arraial do Cabo",
        unidade: "UPA - Unidade de Produção Aquícola",
        document_type: "EVTEAS Conceitual",
        status: :concluido,
        document_link: "https://example.com/document13.pdf"
      },
      %{
        municipio: "Arraial do Cabo",
        unidade: "UPA - Unidade de Produção Aquícola",
        document_type: "Atualização EVTEAS",
        status: :em_andamento,
        document_link: "https://example.com/document14.pdf"
      },
      %{
        municipio: "Arraial do Cabo",
        unidade: "UPA - Unidade de Produção Aquícola",
        document_type: "Plano de Riscos",
        status: :pendente,
        document_link: "https://example.com/document15.pdf"
      },

      # Arraial do Cabo - UPM - Unidade de Produção de Moluscos 1
      %{
        municipio: "Arraial do Cabo",
        unidade: "UPM - Unidade de Produção de Moluscos 1",
        document_type: "EVTEAS Conceitual",
        status: :concluido,
        document_link: "https://example.com/document16.pdf"
      },
      %{
        municipio: "Arraial do Cabo",
        unidade: "UPM - Unidade de Produção de Moluscos 1",
        document_type: "Atualização EVTEAS",
        status: :em_andamento,
        document_link: "https://example.com/document17.pdf"
      },
      %{
        municipio: "Arraial do Cabo",
        unidade: "UPM - Unidade de Produção de Moluscos 1",
        document_type: "Plano de Riscos",
        status: :pendente,
        document_link: "https://example.com/document18.pdf"
      },

      # Arraial do Cabo - UPM - Unidade de Produção de Moluscos 2
      %{
        municipio: "Arraial do Cabo",
        unidade: "UPM - Unidade de Produção de Moluscos 2",
        document_type: "EVTEAS Conceitual",
        status: :concluido,
        document_link: "https://example.com/document19.pdf"
      },
      %{
        municipio: "Arraial do Cabo",
        unidade: "UPM - Unidade de Produção de Moluscos 2",
        document_type: "Atualização EVTEAS",
        status: :em_andamento,
        document_link: "https://example.com/document20.pdf"
      },
      %{
        municipio: "Arraial do Cabo",
        unidade: "UPM - Unidade de Produção de Moluscos 2",
        document_type: "Plano de Riscos",
        status: :pendente,
        document_link: "https://example.com/document21.pdf"
      },

      # Cabo Frio - UBP - Unidade de Beneficiamento de Pescado
      %{
        municipio: "Cabo Frio",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "EVTEAS Conceitual",
        status: :concluido,
        document_link: "https://example.com/document22.pdf"
      },
      %{
        municipio: "Cabo Frio",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "Atualização EVTEAS",
        status: :concluido,
        document_link: "https://example.com/document23.pdf"
      },
      %{
        municipio: "Cabo Frio",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "Cercamento do terreno por parte da Petrobras",
        status: :concluido,
        document_link: "https://example.com/document24.pdf"
      },
      %{
        municipio: "Cabo Frio",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "Instalação de placa por parte da Petrobras",
        status: :concluido,
        document_link: "https://example.com/document25.pdf"
      },
      %{
        municipio: "Cabo Frio",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "Projeto conceitual",
        status: :em_andamento,
        document_link: "https://example.com/document26.pdf"
      },
      %{
        municipio: "Cabo Frio",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "Projeto Básico",
        status: :em_andamento,
        document_link: "https://example.com/document27.pdf"
      },
      %{
        municipio: "Cabo Frio",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "Assinatura do contrato",
        status: :pendente,
        document_link: "https://example.com/document28.pdf"
      },

      # Campos dos Goytacazes - Fábrica de ração, farinha e tratamento de conchas
      %{
        municipio: "Campos dos Goytacazes",
        unidade: "Fábrica de ração, farinha e tratamento de conchas",
        document_type: "EVTEAS Conceitual",
        status: :concluido,
        document_link: "https://example.com/document29.pdf"
      },
      %{
        municipio: "Campos dos Goytacazes",
        unidade: "Fábrica de ração, farinha e tratamento de conchas",
        document_type: "Atualização EVTEAS",
        status: :pendente,
        document_link: "https://example.com/document30.pdf"
      },

      # Campos dos Goytacazes - UBP - Unidade de Beneficiamento de Pescado
      %{
        municipio: "Campos dos Goytacazes",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "EVTEAS Conceitual",
        status: :concluido,
        document_link: "https://example.com/document31.pdf"
      },
      %{
        municipio: "Campos dos Goytacazes",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "Atualização EVTEAS",
        status: :em_andamento,
        document_link: "https://example.com/document32.pdf"
      },
      %{
        municipio: "Campos dos Goytacazes",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "Plano de Riscos",
        status: :pendente,
        document_link: "https://example.com/document33.pdf"
      },

      # Campos dos Goytacazes - UPA - Unidade de Produção Aquícola
      %{
        municipio: "Campos dos Goytacazes",
        unidade: "UPA - Unidade de Produção Aquícola",
        document_type: "EVTEAS Conceitual",
        status: :concluido,
        document_link: "https://example.com/document34.pdf"
      },
      %{
        municipio: "Campos dos Goytacazes",
        unidade: "UPA - Unidade de Produção Aquícola",
        document_type: "Atualização EVTEAS",
        status: :em_andamento,
        document_link: "https://example.com/document35.pdf"
      },
      %{
        municipio: "Campos dos Goytacazes",
        unidade: "UPA - Unidade de Produção Aquícola",
        document_type: "Plano de Riscos",
        status: :pendente,
        document_link: "https://example.com/document36.pdf"
      },

      # Carapebus - UPA - Unidade de Produção Aquícola
      %{
        municipio: "Carapebus",
        unidade: "UPA - Unidade de Produção Aquícola",
        document_type: "EVTEAS Conceitual",
        status: :concluido,
        document_link: "https://example.com/document37.pdf"
      },
      %{
        municipio: "Carapebus",
        unidade: "UPA - Unidade de Produção Aquícola",
        document_type: "Atualização EVTEAS",
        status: :em_andamento,
        document_link: "https://example.com/document38.pdf"
      },
      %{
        municipio: "Carapebus",
        unidade: "UPA - Unidade de Produção Aquícola",
        document_type: "Plano de Riscos",
        status: :pendente,
        document_link: "https://example.com/document39.pdf"
      },

      # Carapebus - Unidade de Produção de alevinos
      %{
        municipio: "Carapebus",
        unidade: "Unidade de Produção de alevinos",
        document_type: "EVTEAS Conceitual",
        status: :em_andamento,
        document_link: "https://example.com/document40.pdf"
      },
      %{
        municipio: "Carapebus",
        unidade: "Unidade de Produção de alevinos",
        document_type: "Atualização EVTEAS",
        status: :em_andamento,
        document_link: "https://example.com/document41.pdf"
      },
      %{
        municipio: "Carapebus",
        unidade: "Unidade de Produção de alevinos",
        document_type: "Plano de Riscos",
        status: :pendente,
        document_link: "https://example.com/document42.pdf"
      },

      # Macaé - UBP - Unidade de Beneficiamento de Pescado
      %{
        municipio: "Macaé",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "EVTEAS Conceitual",
        status: :concluido,
        document_link: "https://example.com/document43.pdf"
      },
      %{
        municipio: "Macaé",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "Atualização EVTEAS",
        status: :em_andamento,
        document_link: "https://example.com/document44.pdf"
      },
      %{
        municipio: "Macaé",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "Plano de Riscos",
        status: :pendente,
        document_link: "https://example.com/document45.pdf"
      },

      # Quissamã - UPA - Unidade de Produção Aquícola
      %{
        municipio: "Quissamã",
        unidade: "UPA - Unidade de Produção Aquícola",
        document_type: "EVTEAS Conceitual",
        status: :concluido,
        document_link: "https://example.com/document46.pdf"
      },
      %{
        municipio: "Quissamã",
        unidade: "UPA - Unidade de Produção Aquícola",
        document_type: "Atualização EVTEAS",
        status: :concluido,
        document_link: "https://example.com/document47.pdf"
      },
      %{
        municipio: "Quissamã",
        unidade: "UPA - Unidade de Produção Aquícola",
        document_type: "Plano de Riscos",
        status: :concluido,
        document_link: "https://example.com/document48.pdf"
      },

      # Quissamã - UPM - Unidade de Produção de Moluscos 1
      %{
        municipio: "Quissamã",
        unidade: "UPM - Unidade de Produção de Moluscos 1",
        document_type: "EVTEAS Conceitual",
        status: :concluido,
        document_link: "https://example.com/document49.pdf"
      },
      %{
        municipio: "Quissamã",
        unidade: "UPM - Unidade de Produção de Moluscos 1",
        document_type: "Atualização EVTEAS",
        status: :em_andamento,
        document_link: "https://example.com/document50.pdf"
      },
      %{
        municipio: "Quissamã",
        unidade: "UPM - Unidade de Produção de Moluscos 1",
        document_type: "Plano de Riscos",
        status: :pendente,
        document_link: "https://example.com/document51.pdf"
      },

      # Quissamã - UPM - Unidade de Produção de Moluscos 2
      %{
        municipio: "Quissamã",
        unidade: "UPM - Unidade de Produção de Moluscos 2",
        document_type: "EVTEAS Conceitual",
        status: :concluido,
        document_link: "https://example.com/document52.pdf"
      },
      %{
        municipio: "Quissamã",
        unidade: "UPM - Unidade de Produção de Moluscos 2",
        document_type: "Atualização EVTEAS",
        status: :em_andamento,
        document_link: "https://example.com/document53.pdf"
      },
      %{
        municipio: "Quissamã",
        unidade: "UPM - Unidade de Produção de Moluscos 2",
        document_type: "Plano de Riscos",
        status: :pendente,
        document_link: "https://example.com/document54.pdf"
      },

      # Rio das Ostras - UPA - Unidade de Produção Aquícola
      %{
        municipio: "Rio das Ostras",
        unidade: "UPA - Unidade de Produção Aquícola",
        document_type: "EVTEAS Conceitual",
        status: :concluido,
        document_link: "https://example.com/document55.pdf"
      },
      %{
        municipio: "Rio das Ostras",
        unidade: "UPA - Unidade de Produção Aquícola",
        document_type: "Atualização EVTEAS",
        status: :em_andamento,
        document_link: "https://example.com/document56.pdf"
      },
      %{
        municipio: "Rio das Ostras",
        unidade: "UPA - Unidade de Produção Aquícola",
        document_type: "Plano de Riscos",
        status: :pendente,
        document_link: "https://example.com/document57.pdf"
      },
      %{
        municipio: "Rio das Ostras",
        unidade: "UPP - Unidade de Processamento de Pescado",
        document_type: "EVTEAS Conceitual",
        status: :em_andamento,
        document_link: "https://example.com/document58.pdf"
      },
      %{
        municipio: "Rio das Ostras",
        unidade: "UPP - Unidade de Processamento de Pescado",
        document_type: "Atualização EVTEAS",
        status: :em_andamento,
        document_link: "https://example.com/document59.pdf"
      },
      %{
        municipio: "Rio das Ostras",
        unidade: "UPP - Unidade de Processamento de Pescado",
        document_type: "Plano de Riscos",
        status: :pendente,
        document_link: "https://example.com/document60.pdf"
      },

      # São Francisco de Itabapoana - UBP - Unidade de Beneficiamento de Pescado
      %{
        municipio: "São Francisco de Itabapoana",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "EVTEAS Conceitual",
        status: :concluido,
        document_link: "https://example.com/document61.pdf"
      },
      %{
        municipio: "São Francisco de Itabapoana",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "Atualização EVTEAS",
        status: :concluido,
        document_link: "https://example.com/document62.pdf"
      },
      %{
        municipio: "São Francisco de Itabapoana",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "Plano de Riscos",
        status: :concluido,
        document_link: "https://example.com/document63.pdf"
      },
      %{
        municipio: "São Francisco de Itabapoana",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "Cercamento do terreno por parte da Petrobras",
        status: :concluido,
        document_link: "https://example.com/document64.pdf"
      },
      %{
        municipio: "São Francisco de Itabapoana",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "Instalação de placa por parte da Petrobras",
        status: :concluido,
        document_link: "https://example.com/document65.pdf"
      },
      %{
        municipio: "São Francisco de Itabapoana",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "Projeto conceitual",
        status: :concluido,
        document_link: "https://example.com/document66.pdf"
      },
      %{
        municipio: "São Francisco de Itabapoana",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "Projeto Básico",
        status: :em_andamento,
        document_link: "https://example.com/document67.pdf"
      },
      %{
        municipio: "São Francisco de Itabapoana",
        unidade: "UBP - Unidade de Beneficiamento de Pescado",
        document_type: "Assinatura do contrato",
        status: :pendente,
        document_link: "https://example.com/document68.pdf"
      },

      # São João da Barra - UPA - Unidade de Produção Aquícola
      %{
        municipio: "São João da Barra",
        unidade: "UPA - Unidade de Produção Aquícola",
        document_type: "EVTEAS Conceitual",
        status: :concluido,
        document_link: "https://example.com/document69.pdf"
      },
      %{
        municipio: "São João da Barra",
        unidade: "UPA - Unidade de Produção Aquícola",
        document_type: "Atualização EVTEAS",
        status: :em_andamento,
        document_link: "https://example.com/document70.pdf"
      },
      %{
        municipio: "São João da Barra",
        unidade: "UPA - Unidade de Produção Aquícola",
        document_type: "Plano de Riscos",
        status: :pendente,
        document_link: "https://example.com/document71.pdf"
      },

      # São João da Barra - UPP - Unidade de Processamento de Pescado
      %{
        municipio: "São João da Barra",
        unidade: "UPP - Unidade de Processamento de Pescado",
        document_type: "EVTEAS Conceitual",
        status: :em_andamento,
        document_link: "https://example.com/document72.pdf"
      },
      %{
        municipio: "São João da Barra",
        unidade: "UPP - Unidade de Processamento de Pescado",
        document_type: "Atualização EVTEAS",
        status: :em_andamento,
        document_link: "https://example.com/document73.pdf"
      },
      %{
        municipio: "São João da Barra",
        unidade: "UPP - Unidade de Processamento de Pescado",
        document_type: "Plano de Riscos",
        status: :pendente,
        document_link: "https://example.com/document74.pdf"
      }
    ]

    Enum.map(documents_data, fn doc ->
      # Buscar o município comparando com o nome original
      municipio = Enum.find(municipios, &(&1.name == doc.municipio))

      unless municipio do
        raise "Município '#{doc.municipio}' não encontrado após normalização."
      end

      # Buscar a unidade comparando com o nome original e município_id
      unidade = Enum.find(units, &(&1.name == doc.unidade && &1.municipio_id == municipio.id))

      unless unidade do
        raise "Unidade '#{doc.unidade}' não encontrada para o município '#{doc.municipio}'."
      end

      # Buscar o tipo de documento comparando com o nome original
      doc_type = Enum.find(document_types, &(&1.name == doc.document_type))

      unless doc_type do
        raise "Tipo de documento '#{doc.document_type}' não encontrado após normalização."
      end

      %Document{
        unit_id: unidade.id,
        document_type_id: doc_type.id,
        status: doc.status,
        document_link: doc.document_link,
        # Você pode manter isso ou usar Ecto.UUID.generate()
        created_by: "00000000-0000-0000-0000-000000000001",
        updated_by: "00000000-0000-0000-0000-000000000001"
      }
    end)
  end
end
