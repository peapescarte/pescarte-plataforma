defmodule ModuloPesquisa.Factory do
  use ExMachina.Ecto, repo: Database.Repo

  alias ModuloPesquisa.Models.Campus
  alias ModuloPesquisa.Models.LinhaPesquisa
  alias ModuloPesquisa.Models.Midia
  alias ModuloPesquisa.Models.Midia.Categoria
  alias ModuloPesquisa.Models.Midia.Tag
  alias ModuloPesquisa.Models.NucleoPesquisa
  alias ModuloPesquisa.Models.Pesquisador
  alias ModuloPesquisa.Models.RelatorioAnualPesquisa
  alias ModuloPesquisa.Models.RelatorioMensalPesquisa
  alias ModuloPesquisa.Models.RelatorioTrimestralPesquisa

  def campus_factory do
    %Campus{
      id_publico: Nanoid.generate_non_secure(),
      nome: sequence(:nome, &"Campus #{&1}"),
      endereco_cep: Identidades.Factory.insert(:endereco).cep,
      acronimo: sequence(:sigla, &"C#{&1 + 1}")
    }
  end

  def categoria_factory do
    %Categoria{
      id_publico: Nanoid.generate_non_secure(),
      nome: sequence("nome")
    }
  end

  def linha_pesquisa_factory do
    %LinhaPesquisa{
      id_publico: Nanoid.generate_non_secure(),
      numero: sequence(:numero, Enum.to_list(1..21)),
      desc_curta: sequence(:descricao_curta, &"Descricao LinhaPesquisa Curta #{&1}"),
      desc: sequence(:descricao_longa, &"Descricao LinhaPesquisa Longa #{&1}"),
      nucleo_pesquisa_letra: insert(:nucleo_pesquisa).letra,
      responsavel_lp_id: insert(:pesquisador).id_publico,
      pesquisadores: insert_list(1, :pesquisador)
    }
  end

  def midia_factory do
    %Midia{
      id_publico: Nanoid.generate_non_secure(),
      autor_id: Identidades.Factory.insert(:usuario).id_publico,
      tipo: sequence(:tipo, ["video", "documento", "imagem"]),
      link: sequence(:link, &"https://example#{&1}.com"),
      nome_arquivo: sequence(:arquivo, &"arquivo#{&1}.jpg"),
      data_arquivo: ~D[2023-05-29],
      restrito?: false,
      tags: []
    }
  end

  def nucleo_pesquisa_factory do
    %NucleoPesquisa{
      id_publico: Nanoid.generate_non_secure(),
      nome: sequence(:name, &"Nucleo #{&1}"),
      desc: sequence(:desc, &"Descricao Nucleo #{&1}"),
      letra: sequence(:letra, &String.upcase("A#{&1}"))
    }
  end

  def pesquisador_factory do
    %Pesquisador{
      id_publico: Nanoid.generate_non_secure(),
      usuario_id: Identidades.Factory.insert(:usuario).id_publico,
      minibio: sequence(:minibiografia, &"Esta e minha minibiografia gerada: #{&1}"),
      bolsa: sequence(:tipo_bolsa, ["ic", "pesquisa", "voluntario"]),
      link_lattes: sequence(:link_lattes, &"http://buscatextual.cnpq.br/buscatextual/:#{&1}"),
      campus_acronimo: insert(:campus).acronimo,
      data_inicio_bolsa: ~D[2023-05-26],
      data_contratacao: ~D[2023-04-23],
      data_fim_bolsa: ~D[2024-05-30],
      formacao: "Advogado",
      link_linkedin: "https://linkedin.com/in/zoedsoupe"
    }
  end

  def relatorio_anual_factory do
    %RelatorioAnualPesquisa{
      data_entrega: ~D[2023-07-30],
      id_publico: Nanoid.generate_non_secure(),
      plano_de_trabalho: "Plano de Trabalho",
      resumo: "Resumo",
      introducao: "Introdução",
      embasamento_teorico: "Embasamento Teórico",
      resultados: "Resultos",
      atividades_academicas: "Atividades Acadêmicas",
      atividades_nao_academicas: "Atividades não Acadêmicas",
      conclusao: "Conclusão",
      referencias: "Referências",
      ano: sequence(:ano, &Kernel.+(2020, &1)),
      mes: 4,
      link: "https//datalake.com/relatorio_anual",
      pesquisador_id: insert(:pesquisador).id_publico,
      status: :pendente
    }
  end

  def relatorio_mensal_factory do
    %RelatorioMensalPesquisa{
      id_publico: Nanoid.generate_non_secure(),
      acao_planejamento: "Ação de planejamento",
      participacao_grupos_estudo: "Participação em grupos de estudo",
      acoes_pesquisa: "Ações de pesquisa",
      participacao_treinamentos: "Participação em Treinamentos",
      publicacao: "Publicação",
      previsao_acoes_pesquisa: "Ações de Pesquisa futura",
      previsao_acao_planejamento: "Ação de Planejamento futura",
      previsao_participacao_grupos_estudo: "Participação em grupos de estudos futura",
      previsao_participacao_treinamentos: "Participação em trinamentos futura",
      ano: 2023,
      mes: sequence(:mes, & &1),
      link: "https//datalake.com/relatorio_anual",
      pesquisador_id: insert(:pesquisador).id_publico,
      status: :pendente
    }
  end

  def relatorio_trimestral_factory do
    %RelatorioTrimestralPesquisa{
      data_entrega: ~D[2023-07-30],
      id_publico: Nanoid.generate_non_secure(),
      titulo: "Titutlo",
      resumo: "Resumo",
      introducao: "Introdução",
      embasamento_teorico: "Embasamento Teórico",
      resultados_preliminares: "Resultados preliminares",
      atividades_academicas: "Atividades Acadêmicas",
      atividades_nao_academicas: "Atividades não Acadêmicas",
      referencias: "Referências",
      ano: 2023,
      mes: sequence(:mes, & &1),
      link: "https//datalake.com/relatorio_anual",
      pesquisador_id: insert(:pesquisador).id_publico,
      status: :pendente
    }
  end

  def tag_factory do
    %Tag{
      id_publico: Nanoid.generate_non_secure(),
      etiqueta: sequence("etiqueta"),
      categoria_nome: insert(:categoria).nome
    }
  end

  def fixture(factory) do
    factory |> build() |> Map.from_struct()
  end
end
