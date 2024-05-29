defmodule PescarteWeb.AgendaController do
  use PescarteWeb, :controller

  def show(conn, _params) do
    table_data = [
      [
        %{
          meta: "Meta 1",
          data: "01/06/2024",
          horario: "09:00",
          duracao: "2 horas",
          atividade: "Reunião de Planejamento",
          local: "Sala de Conferência A",
          participantes: "Equipe A"
        },
        %{
          meta: "Meta 2",
          data: "15/06/2024",
          horario: "14:00",
          duracao: "1 hora",
          atividade: "Revisão de Projetos",
          local: "Sala de Conferência B",
          participantes: "Equipe B"
        },
        %{
          meta: "Meta 3",
          data: "20/06/2024",
          horario: "10:00",
          duracao: "3 horas",
          atividade: "Brainstorming",
          local: "Sala de Reuniões",
          participantes: "Equipe C"
        },
        %{
          meta: "Meta 4",
          data: "25/06/2024",
          horario: "13:00",
          duracao: "2 horas",
          atividade: "Apresentação de Resultados",
          local: "Auditório",
          participantes: "Equipe D"
        }
      ],
      [
        %{
          meta: "Meta 5",
          data: "20/06/2024",
          horario: "10:00",
          duracao: "3 horas",
          atividade: "Brainstorming",
          local: "Sala de Reuniões",
          participantes: "Equipe C"
        },
        %{
          meta: "Meta 6",
          data: "25/06/2024",
          horario: "13:00",
          duracao: "2 horas",
          atividade: "Apresentação de Resultados",
          local: "Auditório",
          participantes: "Equipe D"
        }
      ]
    ]

    mapa =
      table_data
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {lista, index}, acc -> Map.put(acc, index, lista) end)

    render(conn, :show, mapa: mapa)
  end
end
