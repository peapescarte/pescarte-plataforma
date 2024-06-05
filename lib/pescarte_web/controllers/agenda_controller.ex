defmodule PescarteWeb.AgendaController do
  use PescarteWeb, :controller

  def show(conn, _params) do
    table_data = [
      [
        %{
          meta: "1.1.1",
          data: "03/06/2024",
          horario: "08h às 18h ",
          duracao: "10h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão
          Ambiental Pública dos
          Recursos Pesqueiros -
          Turma 2 - São João da
          Barra",
          local: "Sede Pescarte
          São João da Barra ",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "03/06/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão
          Ambiental Pública dos
          Recursos Pesqueiros
          Turma 2 – Búzios",
          local: "Sede Pescarte
          Búzios",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "03, 17 e
          24/06/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão
          Ambiental Pública dos
          Recursos Pesqueiros –
          Turma 3 – Arraial do Cabo",
          local: "Colégio Municipal
          Vera Felizardo
          Arraial do Cabo",
          participantes: "20"
        },
        %{
          meta: "4.1.6",
          data: "03/06/2024",
          horario: "18h30min
          às
          20h30min",
          duracao: "2h",
          atividade: "16ª Reunião do Grupo
          Gestor de Carapebus",
          local: "Sede Pescarte
          Carapebus",
          participantes: "35"
        }
      ],
      [
        %{
          meta: "8.1.1",
          data: "05, 06 e
          07/06/2024",
          horario: "08h às 18h",
          duracao: "24h",
          atividade: "Oficina em Gestão de
          empreendimentos solidários:
          Gestão financeira e contábil
          dos empreendimentos
          (Equipe)",
          local: "Hotel Cravo e
          Canela
          Campos dos
          Goytacazes",
          participantes: "100"
        },
        %{
          meta: "1.1.1",
          data: "10 e
          24/06/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão
          Ambiental Pública dos
          Recursos Pesqueiros –
          Turma 3 – Búzios",
          local: "Sede Pescarte
          Búzios",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "11, 18, 20 e
          25/06/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Construção e
          Gestão de Arranjos
          Produtivos Locais – Turma 4
          – Macaé",
          local: "Sede Pescarte
          Macaé",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "12, 19, 24 e
          26/06/2024",
          horario: "18h30min
          às
          22h30min",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Construção e
          Gestão de Arranjos
          Produtivos Locais – Turma 4 - Carapebus",
          local: "Sede Pescarte
          Carapebus",
          participantes: "20"
        }
      ],
      [
        %{
          meta: "1.5.4",
          data: "14, 15 e
          16/06/2024",
          horario: "08h às 18h",
          duracao: "24h",
          atividade: "2º Encontro Regional do
          PEA Pescarte",
          local: "Royal Macaé
          Palace Hotel",
          participantes: "249"
        },
        %{
          meta: "1.3.1",
          data: "18 e
          19/06/2024",
          horario: "08h às 18h",
          duracao: "20h",
          atividade: "Oficina técnica para os
          grupos de trabalho por
          empreendimento em
          processos ligados à sua
          natureza com os sujeitos da
          ação educativa de Cabo Frio
          – Aquicultura - Turma 1 –
          Módulo 1",
          local: "Unidade Escola de
          Produção Aquícola
          (UEPA)
          Campos dos
          Goytacazes - UENF",
          participantes: ""
        },
        %{
          meta: "1.1.1",
          data: "19 e
          26/06/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão
          Ambiental Pública dos
          Recursos Pesqueiros –
          Turma 4 – Búzios",
          local: "Sede Pescarte
          Búzios",
          participantes: "20"
        },
        %{
          meta: "4.1.17",
          data: "19/06/2024",
          horario: "19h às 22h",
          duracao: "3h",
          atividade: "3ª Assembleia Comunitária
          de Rio das Ostras",
          local: "A definir",
          participantes: "66"
        }
      ],
      [
        %{
          meta: "1.1.2",
          data: "19/06/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade:
            "Oficina de Licenciamento Ambiental: Políticas Públicas e Direitos Sociais para Pesca - Turma 2 - Arraial do Cabo",
          local: "Sede Pescarte Arraial do Cabo",
          participantes: "20"
        },
        %{
          meta: "1.3.4",
          data: "20/06/2024",
          horario: "18h às 20h",
          duracao: "2h",
          atividade: "21ª Reunião do Grupo de Trabalho de São João da Barra",
          local: "Escola Municipal Chrisanto Henrique de Souza",
          participantes: "35"
        },
        %{
          meta: "1.3.1",
          data: "20 e 21/06/2024",
          horario: "09h às 17h",
          duracao: "20h",
          atividade:
            "Oficina técnica para os grupos de trabalho por empreendimento em processos ligados à sua natureza com os sujeitos da ação educativa de São Francisco de Itabapoana - Aquicultura - Turma 1 - Módulo 1",
          local: "Unidade Escola de Produção Aquícola (UEPA) Campos dos Goytacazes - UENF",
          participantes: "16"
        },
        %{
          meta: "1.3.1",
          data: "22 e 29/06/2024",
          horario: "09h às 17h",
          duracao: "20h",
          atividade:
            "Oficina técnica para os grupos de trabalho por empreendimento em processos ligados à sua natureza com os sujeitos da ação educativa de Campos dos Goytacazes - Turma 4 - Módulo 1",
          local: "Unidade Escola de Produção Aquícola (UEPA) Campos dos Goytacazes - UENF",
          participantes: "16"
        }
      ],
      [
        %{
          meta: "1.1.2",
          data: "22 e 29/06/2024",
          horario: "09h às 17h",
          duracao: "8h",
          atividade:
            "Oficina de Licenciamento Ambiental: Redes Colaborativas em Economia Solidária - Turma 4 - Arraial do Cabo",
          local: "Sede Pescarte Arraial do Cabo",
          participantes: "20"
        },
        %{
          meta: "1.3.1",
          data: "24/06/2024",
          horario: "09h às 17h",
          duracao: "8h",
          atividade:
            "Oficina técnica para os grupos de trabalho por empreendimento em processos ligados à sua natureza com os sujeitos da ação educativa de Campos dos Goytacazes - Turma 3 - Módulo 1",
          local: "Unidade Escola de Produção Aquícola (UEPA) Campos dos Goytacazes - UENF",
          participantes: "16"
        },
        %{
          meta: "1.3.1",
          data: "25/06/2024",
          horario: "09h às 17h",
          duracao: "8h",
          atividade:
            "Oficina técnica para os grupos de trabalho por empreendimento em processos ligados à sua natureza com os sujeitos da ação educativa de Campos dos Goytacazes - Turma 2 - Módulo 1",
          local: "Unidade Escola de Produção Aquícola (UEPA) Campos dos Goytacazes - UENF",
          participantes: "16"
        },
        %{
          meta: "1.1.1",
          data: "25/06/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade:
            "Oficina de Gestão em Empreendimentos Solidários: Gestão financeira e contábil dos empreendimentos -Turma 1 - Cabo Frio",
          local: "Sede Pescarte Cabo Frio",
          participantes: "20"
        }
      ],
      [
        %{
          meta: "1.3.1",
          data: "27 e 28/06/2024",
          horario: "09h às 17h",
          duracao: "20h",
          atividade:
            "Oficina técnica para os grupos de trabalho por empreendimento em processos ligados à sua natureza com os sujeitos da ação educativa de São Francisco de Itabapoana - Turma 1 - Módulo 2",
          local: "Unidade Escola de Produção Aquícola (UEPA) Campos dos Goytacazes - UENF",
          participantes: "16"
        },
        %{
          meta: "",
          data: "27/06/2024",
          horario: "15h às 17h",
          duracao: "2h",
          atividade: "Sessão de Encontros:
          mulheres e direitos,
          articulação do Núcleo de
          Direitos e Benefícios (NDB
          PEA Pescarte)",
          local: "Virtual",
          participantes: "20"
        },
        %{
          meta: "1.3.4",
          data: "28/06/2024",
          horario: "15h às 17h",
          duracao: "2h",
          atividade: "21ª Reunião do Grupo de
          Trabalho de Quissamã",
          local: "Barra do Furado –
          Casa de Vilton",
          participantes: "35"
        },
        %{
          meta: "1.1.1",
          data: "28/06/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão
          Ambiental Pública dos
          Recursos Pesqueiros
          Turma 1 – Arraial do Cabo",
          local: "Sede Pescarte
          Arraial do Cabo",
          participantes: "20"
        }
      ],
      [
        %{
          meta: "1.1.2",
          data: "29/06/2024",
          horario: "09h às 17h",
          duracao: "8h",
          atividade: "Oficina de Licenciamento
          Ambiental: Populações
          tradicionais e conflitos no
          Brasil – Turma 4
          Carapebus",
          local: "Sede Pescarte
          Carapebus",
          participantes: "20"
        },
        %{
          meta: "1.1.2",
          data: "29/06/2024",
          horario: "09h às 17h",
          duracao: "8h",
          atividade: "Oficina de Licenciamento
          Ambiental: Economia
          Solidária e Estratégia de
          desenvolvimento – Turma 4
          Macaé",
          local: "Sede Pescarte
          Macaé",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "01/07/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão
          Ambiental Pública dos
          Recursos Pesqueiros –
          Turma 3 – Arraial do Cabo",
          local: "Colégio Municipal
          Vera Felizardo
          Arraial do Cabo",
          participantes: "20"
        },
        %{
          meta: "4.1.6",
          data: "01/07/2024",
          horario: "18h30min
          às
          20h30min",
          duracao: "2h",
          atividade: "17ª Reunião do Grupo
          Gestor de Carapebus",
          local: "Sede Pescarte
          Carapebus",
          participantes: "35"
        }
      ],
      [
        %{
          meta: "1.3.1",
          data: "02/07/2024",
          horario: "09h às 17h",
          duracao: "8h",
          atividade: "Oficina técnica para os
          grupos de trabalho por
          empreendimento em
          processos ligados à sua
          natureza com os sujeitos da
          ação educativa de Campos
          dos Goytacazes – Turma 2 –
          Módulo 1",
          local: "Unidade Escola de
          Produção Aquícola
          (UEPA)
          Campos dos
          Goytacazes - UENF",
          participantes: "16"
        },
        %{
          meta: "1.1.1",
          data: "02, 09,
          16/07/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão financeira
          e contábil dos
          empreendimentos -Turma 1 - Cabo Frio",
          local: "Sede Pescarte
          Cabo Frio",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "02, 09, 16 e
          23/07/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Economia
          solidária e controle social –
          Turma -2 - Macaé",
          local: "Sede Pescarte
          Macaé",
          participantes: "20"
        },
        %{
          meta: "1.1.4",
          data: "03/07/2024",
          horario: "16h às 18h",
          duracao: "2h",
          atividade: "16ª Reunião do Grupo de
          Acompanhamento de Obras
          de São Francisco de
          Itabapoana",
          local: "Sede Pescarte
          São Francisco de
          Itabapoana",
          participantes: "35"
        }
      ],
      [
        %{
          meta: "4.1.17",
          data: "04/07/2024",
          horario: "18h30min
          às
          20h30min",
          duracao: "2h",
          atividade: "8ª Assembleia Comunitária
          de Búzios",
          local: "S.E.B.",
          participantes: "66"
        },
        %{
          meta: "1.1.4",
          data: "05/07/2024",
          horario: "14h às 16h",
          duracao: "2h",
          atividade: "16ª Reunião do Grupo de
          Acompanhamento de Obras
          de Quissamã",
          local: "Sede Pescarte
          Quissamã",
          participantes: "35"
        },
        %{
          meta: "1.1.2",
          data: "06/07/2024",
          horario: "09h às 17h",
          duracao: "8h",
          atividade: "Oficina de Licenciamento
          Ambiental: Populações
          tradicionais e conflitos no
          Brasil – Turma 4
          Carapebus",
          local: "Sede Pescarte
          Carapebus",
          participantes: "20"
        },
        %{
          meta: "1.1.2",
          data: "06/07/2024",
          horario: "09h às 17h",
          duracao: "8h",
          atividade: "Oficina de Licenciamento
          Ambiental: Economia
          Solidária e Estratégia de
          desenvolvimento – Turma 4
          Macaé",
          local: "Sede Pescarte
          Macaé",
          participantes: "20"
        }
      ],
      [
        %{
          meta: "1.1.1",
          data: "06 e
          13/07/2024",
          horario: "09h às 17h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão
          Ambiental Pública dos
          Recursos Pesqueiros –
          Turma 4 – Arraial do Cabo",
          local: "Sede Pescarte
          Arraial do Cabo",
          participantes: "20"
        },
        %{
          meta: "1.1.2",
          data: "08,10, 15 e
          17/07/2024",
          horario: "18h30min
          às
          22h30min",
          duracao: "4h",
          atividade: "Oficina de Licenciamento
          Ambiental: Políticas Públicas
          e Direitos Sociais para
          Pesca – Turma 4
          Carapebus",
          local: "Sede Pescarte
          Carapebus",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "08/07/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão
          Ambiental Pública dos
          Recursos Pesqueiros
          Turma 3 – Búzios",
          local: "Sede Pescarte
          Búzios",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "09 e 30/07",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão Ambiental Pública dos
          Recursos Pesqueiros
          Turma 2 – Arraial do Cabo",
          local: "Colégio Municipal
          Vera Felizardo
          Arraial do Cabo",
          participantes: "20"
        }
      ],
      [
        %{
          meta: "1.1.4",
          data: "11/07/2024",
          horario: "15h às 17h",
          duracao: "2h",
          atividade: "16ª Reunião do Grupo de
          Acompanhamento de Obras
          de Campos dos Goytacazes",
          local: "Sede Pescarte
          Campos dos
          Goytacazes",
          participantes: "35"
        },
        %{
          meta: "1.3.1",
          data: "11 e
          12/07/2024",
          horario: "09h às 17h",
          duracao: "8h",
          atividade: "Oficina técnica para os
          grupos de trabalho por
          empreendimento em
          processos ligados à sua
          natureza com os sujeitos da
          ação educativa de São
          Francisco de Itabapoana –
          Turma 1 – Módulo 3",
          local: "Unidade Escola de
          Produção Aquícola
          (UEPA)
          Campos dos
          Goytacazes - UENF",
          participantes: "16"
        },
        %{
          meta: "4.1.6",
          data: "13/07/2024",
          horario: "09h30min
          às
          12h30min",
          duracao: "2h",
          atividade: "14ª Reunião do Grupo
          Gestor de Rio das Ostras",
          local: "Sede Pescarte
          Rio das Ostras",
          participantes: "35"
        },
        %{
          meta: "1.3.1",
          data: "15/07/2024",
          horario: "09h as 17h",
          duracao: "8h",
          atividade: "Oficina técnica para os
          grupos de trabalho por
          empreendimento em
          processos ligados à sua
          natureza com os sujeitos da
          ação educativa de Campos
          dos Goytacazes – Turma 3 –
          Módulo 1",
          local: "Unidade Escola de
          Produção Aquícola
          (UEPA)
          Campos dos
          Goytacazes - UENF",
          participantes: "16"
        }
      ],
      [
        %{
          meta: "1.1.4",
          data: "15/07/2024",
          horario: "18h às 20h",
          duracao: "2h",
          atividade: "16ª Reunião do Grupo de
          Acompanhamento de Obras
          de Arraial do Cabo",
          local: "Sede Pescarte
          Arraial do Cabo",
          participantes: "35"
        },
        %{
          meta: "1.1.1 ",
          data: "16 e
          24/07/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão
          Ambiental Pública dos
          Recursos Pesqueiros
          Turma 4 – Búzios",
          local: "Sede Pescarte
          Búzios",
          participantes: "20"
        },
        %{
          meta: "1.3.5",
          data: "19, 20 e
          21/07/2024",
          horario: "08h às 18h",
          duracao: "24h",
          atividade: "4ª Visita Técnica",
          local: "Rio de Janeiro
          OCB",
          participantes: "45"
        },
        %{
          meta: "1.1.1",
          data: "22 e
          29/07/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão financeira
          e contábil dos
          empreendimentos -Turma 1
          Búzios",
          local: "Sede Pescarte
          Búzios",
          participantes: "20"
        }
      ],
      [
        %{
          meta: "1.3.1",
          data: "23 e
          24/07/2024",
          horario: "08h às 18h",
          duracao: "20h",
          atividade: "Oficina técnica para os
          grupos de trabalho por
          empreendimento em
          processos ligados à sua
          natureza com os sujeitos da
          ação educativa de Cabo Frio
          – Aquicultura - Turma 1 –
          Módulo 2",
          local: "Unidade Escola de
          Produção Aquícola
          (UEPA)
          Campos dos
          Goytacazes - UENF",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "23/07/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Economia
          solidária e controle social
          Turma 2 - Macaé",
          local: "Sede Pescarte
          Macaé",
          participantes: "20"
        },
        %{
          meta: "1.3.1",
          data: "25/07/2024",
          horario: "09h as 17h",
          duracao: "8h",
          atividade: "Oficina técnica para os
          grupos de trabalho por
          empreendimento em
          processos ligados à sua
          natureza com os sujeitos da
          ação educativa de Campos
          dos Goytacazes – Turma 1 –
          Módulo 3",
          local: "Unidade Escola de
          Produção Aquícola
          (UEPA)
          Campos dos
          Goytacazes - UENF",
          participantes: "16"
        },
        %{
          meta: "",
          data: "25/07/2024",
          horario: "15h às 17h",
          duracao: "2h",
          atividade: "Sessão de Encontros:
          mulheres e direitos,
          articulação do Núcleo de
          Direitos e Benefícios (NDB
          PEA Pescarte)",
          local: "Virtual",
          participantes: "20"
        }
      ],
      [
        %{
          meta: "1.1.4",
          data: "25/07/2024",
          horario: "18h às 20h",
          duracao: "2h",
          atividade: "16ª Reunião do Grupo de
          Acompanhamento de Obras
          de São João da Barra",
          local: "Escola Municipal
          Chrisanto Henrique
          de Souza
          São João da Barra",
          participantes: "35"
        },
        %{
          meta: "1.3.1",
          data: "26 e
          27/07/2024",
          horario: "09h às 17h",
          duracao: "20h",
          atividade: "Oficina técnica para os
          grupos de trabalho por
          empreendimento em
          processos ligados à sua
          natureza com os sujeitos da
          ação educativa de
          Quissamã – Turma 1 –
          Módulo 3",
          local: "Unidade Escola de
          Produção Aquícola
          (UEPA)
          Campos dos
          Goytacazes - UENF",
          participantes: "16"
        },
        %{
          meta: "1.3.1",
          data: "27 e
          28/07/2024",
          horario: "09h as 17h",
          duracao: "20h",
          atividade: "Oficina técnica para os
          grupos de trabalho por
          empreendimento em
          processos ligados à sua
          natureza com os sujeitos da
          ação educativa de Rio das
          Ostras – Aquicultura - Turma
          1 – Módulo 1",
          local: "Unidade Escola de
          Produção Aquícola
          (UEPA)
          Campos dos
          Goytacazes - UENF",
          participantes: ""
        },
        %{
          meta: "1.1.1",
          data: "31/07/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão financeira
          e contábil dos
          empreendimentos - Turma 2
          Búzios",
          local: "Sede Pescarte
          Búzios",
          participantes: "20"
        }
      ],
      [
        %{
          meta: "1.1.4",
          data: "31/07/2024",
          horario: "18h às 20h",
          duracao: "2h",
          atividade: "16ª Reunião do Grupo de
          Acompanhamento de Obras
          de Cabo Frio",
          local: "Sede Pescarte
          Cabo Frio",
          participantes: "35"
        },
        %{
          meta: "1.3.1",
          data: "01/08/2024",
          horario: "09h às 17h",
          duracao: "8h",
          atividade: "Oficina técnica para os
          grupos de trabalho por
          empreendimento em
          processos ligados à sua
          natureza com os sujeitos da
          ação educativa de Campos
          dos Goytacazes– Turma 1 –
          Módulo 3",
          local: "Unidade Escola de
          Produção Aquícola
          (UEPA)
          Campos dos
          Goytacazes - UENF",
          participantes: "16"
        },
        %{
          meta: "1.3.1",
          data: "03 e
          04/08/2024",
          horario: "09h as 17h",
          duracao: "20h",
          atividade: "Oficina técnica para os
          grupos de trabalho por
          empreendimento em
          processos ligados à sua
          natureza com os sujeitos da
          ação educativa de Rio das
          Ostras – Aquicultura - Turma
          1 – Módulo 2",
          local: "Unidade Escola de
          Produção Aquícola
          (UEPA)
          Campos dos
          Goytacazes - UENF",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "05, 12, 14 e
          16/08/2024",
          horario: "15h às 19h",
          duracao: "4h",
          atividade: "Oficina em Gestão de
          empreendimentos solidários:
          Gestão financeira e contábil
          dos empreendimentos
          Turma 1 – São Francisco de
          Itabapoana",
          local: "Barracão de
          Gargaú
          São Francisco de
          Itabapoana",
          participantes: "20"
        }
      ],
      [
        %{
          meta: "1.1.1",
          data: "05, 12, 19 e
          26/08/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão
          Ambiental Pública dos
          Recursos Pesqueiros
          Turma 2 – Arraial do Cabo",
          local: "Sede Pescarte
          Arraial do Cabo",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "05 e
          12/08/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão financeira
          e contábil dos
          empreendimentos - Turma 1
          Búzios",
          local: "Sede Pescarte
          Búzios",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "05/08/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Economia
          solidária e controle social
          Turma 02 – Macaé",
          local: "Sede Pescarte
          Macaé",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "06, 13, 20 e
          27/08/2024",
          horario: "14h às 18h",
          duracao: "4h",
          atividade: "Oficina em Gestão de
          empreendimentos solidários:
          Gestão financeira e contábil
          dos empreendimentos
          Turma 1 – São João da
          Barra",
          local: "Sede Pescarte
          São João da Barra",
          participantes: "20"
        }
      ],
      [
        %{
          meta: "1.3.4",
          data: "07, 08 e
          09/08/2024",
          horario: "08h às 18h",
          duracao: "24h",
          atividade: "11ª Reunião de Avaliação e
          Realinhamento de Equipe",
          local: "A definir",
          participantes: "100"
        },
        %{
          meta: "1.1.1",
          data: "12, 14, 19 e
          21/08/2024",
          horario: "18h30min
          às
          22h30min",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão
          Ambiental Pública dos
          Recursos Pesqueiros
          Turma 2 - Carapebus",
          local: "Sede Pescarte
          Carapebus",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "13 e
          27/08/2024",
          horario: "8h30min às
          12h30min",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão financeira
          e contábil dos
          empreendimentos - Turma 2
          Cabo Frio",
          local: "Rede Observação
          Cabo Frio",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "13, 20 e
          27/08/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão de
          Empreendimentos
          Solidários: Economia
          solidária e controle social
          Turma 02 – Macaé",
          local: "Sede Pescarte
          Macaé",
          participantes: "20"
        }
      ],
      [
        %{
          meta: "1.1.1",
          data: "13 e
          27/08/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão
          Ambiental Pública dos
          Recursos Pesqueiros - Turma 2 – Arraial do Cabo",
          local: "Colégio Municipal
          Vera Felizardo
          Arraial do Cabo",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "14, 21, 28 e
          29/08/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão financeira
          e contábil dos
          empreendimentos -Turma 1
          Rio das Ostras",
          local: "A definir",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "14, 21 e
          28/08/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão financeira
          e contábil dos
          empreendimentos - Turma 2
          Búzios",
          local: "Sede Pescarte
          Búzios",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "15, 16, 22 e
          23/08/2024",
          horario: "14h às 18h",
          duracao: "4h",
          atividade: "Oficina em Gestão de
          empreendimentos solidários:
          Gestão financeira e contábil
          dos empreendimentos
          Turma 1 - Quissamã",
          local: "Sede Pescarte
          Quissamã",
          participantes: "20"
        }
      ],
      [
        %{
          meta: "1.3.1",
          data: "17 e
          24/08/2024",
          horario: "09h às 17h",
          duracao: "8h",
          atividade: "Oficina técnica para os
          grupos de trabalho por
          empreendimento em
          processos ligados à sua
          natureza com os sujeitos da ação educativa de
          Carapebus – Aquicultura –
          Turma 1 - Módulo II",
          local: "Unidade Escola de
          Produção Aquícola
          (UEPA)
          Campos dos Goytacazes - UENF",
          participantes: "20"
        },
        %{
          meta: "1.1.2",
          data: "17 e
          24/08/2024",
          horario: "09h às 17h",
          duracao: "8h",
          atividade: "Oficina de Licenciamento
          Ambiental: Economia
          solidária e estratégia de
          desenvolvimento - Turma 02
          Macaé",
          local: "Sede Pescarte
          Macaé",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "19, 21, 26 e
          28/08/2024",
          horario: "14h às 18h",
          duracao: "4h",
          atividade: "Oficina em Gestão de
          empreendimentos solidários:
          Gestão financeira e contábil
          dos empreendimentos
          Turma 1 – Campos dos
          Goytacazes",
          local: "Escola Municipal
          Claudia Almeida –
          Vila do Sol
          Farol de São
          Thomé",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "19, 21, 26 e
          28/08/2024",
          horario: "14h às 18h",
          duracao: "4h",
          atividade: "Oficina em Gestão de
          empreendimentos solidários:
          Gestão financeira e contábil
          dos empreendimentos
          Turma 2- São Francisco de
          Itabapoana",
          local: "Centro Cultural Luz
          da Barra
          Barra do
          Itabapoana",
          participantes: "20"
        }
      ],
      [
        %{
          meta: "1.1.1",
          data: "19 e
          26/08/2024",
          horario: "18h às 22h",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão financeira
          e contábil dos
          empreendimentos - Turma 3 - Búzios",
          local: "Sede Pescarte
          Búzios",
          participantes: "20"
        },
        %{
          meta: "1.3.1",
          data: "20 e
          21/08/2024",
          horario: "08h às 18h",
          duracao: "20h",
          atividade: "Oficina técnica para os
          grupos de trabalho por
          empreendimento em
          processos ligados à sua
          natureza com os sujeitos da
          ação educativa de Cabo Frio
          – Aquicultura - Turma 1 –
          Módulo 3",
          local: "Unidade Escola de
          Produção Aquícola
          (UEPA)
          Campos dos
          Goytacazes - UENF",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "20, 23, 27 e
          30/08/2024",
          horario: "14h às 18h",
          duracao: "4h",
          atividade: "Oficina em Gestão de
          empreendimentos solidários:
          Gestão financeira e contábil
          dos empreendimentos
          Turma 2 – Campos dos
          Goytacazes",
          local: "Escola Municipal
          Claudia Almeida –
          Vila do Sol
          Farol de São
          Thomé",
          participantes: "20"
        },
        %{
          meta: "1.1.1",
          data: "24 e
          31/08/2024",
          horario: "09h às 17h",
          duracao: "8h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão financeira
          e contábil dos
          empreendimentos -Turma 3
          – Cabo Frio",
          local: "Sede Pescarte
          Cabo Frio",
          participantes: "20"
        }
      ],
      [
        %{
          meta: "1.3.1",
          data: "24 e
          31/08/2024",
          horario: "09h às 17h",
          duracao: "8h",
          atividade: "Oficina técnica para os
          grupos de trabalho por
          empreendimento em
          processos ligados à sua natureza com os sujeitos da
          ação educativa de São
          João da Barra – Turma 1 –
          Módulo 3",
          local: "Unidade Escola de
          Produção Aquícola (UEPA)
          Campos dos
          Goytacazes - UENF",
          participantes: "16"
        },
        %{
          meta: "1.1.1",
          data: "28/08/2024",
          horario: "13h30min
          às
          17h30min",
          duracao: "4h",
          atividade: "Oficina de Gestão em
          Empreendimentos
          Solidários: Gestão financeira
          e contábil dos
          empreendimentos -Turma 4
          – Cabo Frio",
          local: "A definir
          Cabo Frio",
          participantes: "20"
        },
        %{
          meta: "1.3.1",
          data: "31/08/2024",
          horario: "09h às 17h",
          duracao: "20h",
          atividade: "Oficina técnica para os
          grupos de trabalho por
          empreendimento em
          processos ligados à sua
          natureza com os sujeitos da
          ação educativa de
          Rio das Ostras – Aquicultura
          – Turma 1 – Módulo 3",
          local: "Unidade Escola de
          Produção Aquícola
          (UEPA)
          Campos dos
          Goytacazes - UENF",
          participantes: ""
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
