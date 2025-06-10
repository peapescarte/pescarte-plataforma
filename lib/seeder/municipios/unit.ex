defmodule Seeder.UnitSeeder do
  alias Pescarte.Municipios.Unit

  def entries(municipios) do
    units_data = [
      # Armação dos Búzios
      %{
        municipio: "Armação dos Búzios",
        name: "UPP - Unidade de Processamento de Pescado",
        situation: "Em andamento",
        next_step:
          "Finalização do EVTEAS conceitual e aprovação de atualização a partir de área definida, para iniciar elaboração de plano de riscos."
      },
      %{
        municipio: "Armação dos Búzios",
        name: "UPM - Unidade de Produção de Moluscos 3",
        situation: "Concluído",
        next_step:
          "Finalização de atualização de EVTEAS, aprovação e elaboração do plano de riscos."
      },
      %{
        municipio: "Armação dos Búzios",
        name: "Unidade de Produção de sementes",
        situation: "Em fila para iniciar, pendente",
        next_step: "Elaboração do estudo de viabilidade técnica em fila para iniciar."
      },

      # Arraial do Cabo
      %{
        municipio: "Arraial do Cabo",
        name: "Unidade de Beneficiamento de Moluscos",
        situation: "Em andamento",
        next_step: "Atualização de EVTEAS a partir de área definida."
      },
      %{
        municipio: "Arraial do Cabo",
        name: "UPP - Unidade de Processamento de Pescado",
        situation: "Em andamento",
        next_step:
          "Finalização do EVTEAS conceitual e atualização a partir de área definida para iniciar elaboração de plano de riscos."
      },
      %{
        municipio: "Arraial do Cabo",
        name: "UPA - Unidade de Produção Aquícola",
        situation: "Concluído",
        next_step: "Elaboração de plano de riscos."
      },
      %{
        municipio: "Arraial do Cabo",
        name: "UPM - Unidade de Produção de Moluscos 1",
        situation: "Concluído",
        next_step: "Aprovação de atualização de EVTEAS e elaboração do Plano de riscos."
      },
      %{
        municipio: "Arraial do Cabo",
        name: "UPM - Unidade de Produção de Moluscos 2",
        situation: "Concluído",
        next_step: "Aprovação de atualização de EVTEAS e elaboração do Plano de riscos."
      },

      # Cabo Frio
      %{
        municipio: "Cabo Frio",
        name: "UBP - Unidade de Beneficiamento de Pescado",
        situation: "Concluído",
        next_step: "Elaboração e planejamento do projeto."
      },

      # Campos dos Goytacazes
      %{
        municipio: "Campos dos Goytacazes",
        name: "Fábrica de ração, farinha e tratamento de conchas",
        situation: "Concluído",
        next_step: "Elaboração de atualização de viabilidade técnica."
      },
      %{
        municipio: "Campos dos Goytacazes",
        name: "UBP - Unidade de Beneficiamento de Pescado",
        situation: "Concluído",
        next_step: "Término de atualização de EVTEAS e elaboração de plano de riscos."
      },
      %{
        municipio: "Campos dos Goytacazes",
        name: "UPA - Unidade de Produção Aquícola",
        situation: "Concluído",
        next_step: "Término de atualização de EVTEAS e elaboração de plano de riscos."
      },

      # Carapebus
      %{
        municipio: "Carapebus",
        name: "UPA - Unidade de Produção Aquícola",
        situation: "Concluído",
        next_step: "Término de atualização de EVTEAS e elaboração de plano de riscos."
      },
      %{
        municipio: "Carapebus",
        name: "Unidade de Produção de alevinos",
        situation: "Em andamento",
        next_step: "Término de atualização de EVTEAS e elaboração de plano de riscos."
      },

      # Macaé
      %{
        municipio: "Macaé",
        name: "UBP - Unidade de Beneficiamento de Pescado",
        situation: "Concluído",
        next_step: "Término de atualização de EVTEAS e elaboração de plano de riscos."
      },

      # Quissamã
      %{
        municipio: "Quissamã",
        name: "UPA - Unidade de Produção Aquícola",
        situation: "Concluído",
        next_step: "Término do projeto básico e assinatura do contrato."
      },
      %{
        municipio: "Quissamã",
        name: "UPM - Unidade de Produção de Moluscos 1",
        situation: "Concluído",
        next_step: "Aprovação de atualização de EVTEAS e elaboração do Plano de riscos."
      },
      %{
        municipio: "Quissamã",
        name: "UPM - Unidade de Produção de Moluscos 2",
        situation: "Concluído",
        next_step: "Aprovação de atualização de EVTEAS e elaboração do Plano de riscos."
      },

      # Rio das Ostras
      %{
        municipio: "Rio das Ostras",
        name: "UPA - Unidade de Produção Aquícola",
        situation: "Concluído",
        next_step: "Término de atualização de EVTEAS e elaboração de plano de riscos."
      },
      %{
        municipio: "Rio das Ostras",
        name: "UPP - Unidade de Processamento de Pescado",
        situation: "Em andamento",
        next_step:
          "Finalização do EVTEAS conceitual e atualização a partir de área definida para iniciar elaboração de plano de riscos."
      },

      # São Francisco de Itabapoana
      %{
        municipio: "São Francisco de Itabapoana",
        name: "UBP - Unidade de Beneficiamento de Pescado",
        situation: "Concluído",
        next_step: "Término do projeto básico e assinatura do contrato."
      },

      # São João da Barra
      %{
        municipio: "São João da Barra",
        name: "UPA - Unidade de Produção Aquícola",
        situation: "Concluído",
        next_step: "Término de atualização de EVTEAS e elaboração de plano de riscos."
      },
      %{
        municipio: "São João da Barra",
        name: "UPP - Unidade de Processamento de Pescado",
        situation: "Em andamento",
        next_step:
          "Finalização do EVTEAS conceitual e atualização a partir de área definida para iniciar elaboração de plano de riscos."
      }
    ]

    Enum.map(units_data, fn unit ->
      # Buscar o município apenas comparando com o nome original
      municipio =
        Enum.find(municipios, fn m ->
          m.name == unit.municipio
        end)

      unless municipio do
        raise "Município '#{unit.municipio}' não encontrado após normalização."
      end

      %Unit{
        municipio_id: municipio.id,
        name: unit.name,
        situation: unit.situation,
        next_step: unit.next_step,
        created_by: "00000000-0000-0000-0000-000000000001",
        updated_by: "00000000-0000-0000-0000-000000000001"
      }
    end)
  end
end
