defmodule Seeder.ModuloPesquisa.RelatorioPesquisa do
  alias Pescarte.Database.Repo.Replica
  alias Pescarte.Identidades.Models.Usuario
  alias Pescarte.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.ModuloPesquisa.Models.RelatorioPesquisa
  @behaviour Seeder.Entry

  defp pesquisador_id_by_cpf(cpf) do
    usuario = Replica.get_by!(Usuario, cpf: cpf)
    pesquisador = Replica.get_by!(Pesquisador, usuario_id: usuario.id_publico)
    pesquisador.id_publico
  end

  @impl true
  def entries do
    [
      %RelatorioPesquisa{
        tipo: :mensal,
        data_inicio: ~D[2023-09-10],
        data_fim: ~D[2023-10-10],
        data_entrega: ~D[2023-10-10],
        data_limite: ~D[2023-10-15],
        status: :entregue,
        conteudo_mensal: %{
          acao_planejamento:
            "Organização de reuniões mensais com líderes da comunidade pesqueira",
          participacao_grupos_estudo:
            "Participação ativa no grupo de estudo sobre sustentabilidade pesqueira",
          acoes_pesquisa:
            "Realização de entrevistas com pescadores locais para entender suas práticas",
          participacao_treinamentos:
            "Participação no treinamento anual sobre boas práticas de pesca",
          publicacao:
            "Publicação de artigo sobre desafios enfrentados pelas comunidades pesqueiras locais",
          previsao_acao_planejamento:
            "Expansão das reuniões para envolver mais membros da comunidade",
          previsao_participacao_grupos_estudo:
            "Planejamento para criar um novo grupo de estudo focado em preservação marinha",
          previsao_participacao_treinamentos:
            "Previsão de participação em treinamentos avançados de gestão pesqueira",
          previsao_acoes_pesquisa:
            "Início de uma nova pesquisa para avaliar o impacto das mudanças climáticas nas atividades de pesca"
        },
        pesquisador_id: pesquisador_id_by_cpf("13359017790"),
        id_publico: Nanoid.generate_non_secure()
      },
      %RelatorioPesquisa{
        tipo: :mensal,
        data_inicio: ~D[2023-11-10],
        data_fim: ~D[2023-12-10],
        data_entrega: ~D[2023-12-14],
        data_limite: ~D[2023-12-15],
        status: :entregue,
        conteudo_mensal: %{
          acao_planejamento: "Realização de workshops sobre metodologias de pesquisa",
          participacao_grupos_estudo: "Participação ativa em dois grupos de estudo",
          acoes_pesquisa: "Condução de entrevistas com participantes do estudo",
          participacao_treinamentos: "Participação no treinamento anual de pesquisa",
          publicacao: "Publicação de artigo em conferência internacional",
          previsao_acao_planejamento: "Planejamento para organizar uma conferência",
          previsao_participacao_grupos_estudo:
            "Planejamento para se juntar a um novo grupo de estudo",
          previsao_participacao_treinamentos:
            "Planejamento para participar de treinamentos futuros",
          previsao_acoes_pesquisa: "Planejamento para iniciar nova pesquisa"
        },
        pesquisador_id: pesquisador_id_by_cpf("13359017790"),
        id_publico: Nanoid.generate_non_secure()
      },
      %RelatorioPesquisa{
        tipo: :anual,
        data_inicio: ~D[2023-01-01],
        data_fim: ~D[2023-12-31],
        data_limite: ~D[2024-01-10],
        data_entrega: ~D[2024-01-02],
        status: :entregue,
        conteudo_anual: %{
          plano_de_trabalho: """
            - Definição dos objetivos de pesquisa para o ano.
            - Planejamento das etapas e métodos de coleta de dados.
            - Distribuição de tarefas entre os membros da equipe.
          """,
          resumo: """
            Durante o ano, realizamos uma série de atividades de pesquisa abrangendo diversas áreas.
            Este resumo destaca os principais pontos abordados e resultados obtidos.
          """,
          introducao: """
            A introdução fornece uma visão geral do contexto da pesquisa, destacando a relevância do tema
            e as principais questões que orientam nosso trabalho.
          """,
          embasamento_teorico: """
            Nesta seção, apresentamos uma revisão crítica da literatura existente relacionada ao nosso campo de estudo.
            Exploramos teorias e pesquisas anteriores que fundamentam nosso trabalho.
          """,
          resultados: """
            - Análise estatística dos dados coletados.
            - Apresentação de gráficos e tabelas que ilustram os principais resultados.
            - Discussão sobre as descobertas mais significativas.
          """,
          atividades_academicas: """
            - Participação em conferências regionais e internacionais.
            - Apresentação de artigos em eventos acadêmicos.
            - Colaboração em projetos de pesquisa com outras instituições.
          """,
          atividades_nao_academicas: """
            - Palestras e workshops para o público em geral.
            - Participação em eventos comunitários para divulgar a pesquisa.
            - Colaboração com organizações locais para aplicação prática dos resultados.
          """,
          conclusao: """
            A conclusão destaca os principais insights obtidos ao longo do ano, enfatizando a contribuição
            para o avanço do conhecimento na área de pesquisa.
          """,
          referencias: """
            Incluímos uma lista abrangente de todas as fontes bibliográficas utilizadas durante a pesquisa,
            garantindo a transparência e credibilidade do nosso trabalho.
          """
        },
        pesquisador_id: pesquisador_id_by_cpf("13359017790"),
        id_publico: Nanoid.generate_non_secure()
      },
      %RelatorioPesquisa{
        tipo: :trimestral,
        data_inicio: ~D[2023-10-01],
        data_fim: ~D[2023-12-31],
        data_entrega: ~D[2024-01-03],
        data_limite: ~D[2024-01-10],
        status: :entregue,
        conteudo_trimestral: %{
          titulo: "Relatório Trimestral de Pesquisa",
          introducao:
            "Este relatório aborda os desenvolvimentos recentes na comunidade pesqueira.",
          embasamento_teorico:
            "Baseamos nossa pesquisa nos princípios da sustentabilidade e conservação marinha.",
          resultados_preliminares:
            "Os resultados preliminares indicam um aumento na população de determinadas espécies de peixes.",
          atividades_academicas:
            "Realizamos workshops educativos sobre práticas de pesca sustentável.",
          atividades_nao_academicas:
            "Colaboramos com pescadores locais para promover a conscientização ambiental.",
          referencias: "Smith, J. et al. (2023). Sustentabilidade na Pesca: Um Guia Abrangente."
        },
        pesquisador_id: pesquisador_id_by_cpf("13359017790"),
        id_publico: Nanoid.generate_non_secure()
      }
    ]
  end
end
