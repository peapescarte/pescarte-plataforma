defmodule ModuloPesquisa.Factory do
  use ExMachina.Ecto, repo: Database.Repo

  alias ModuloPesquisa.Models.Campus
  alias ModuloPesquisa.Models.LinhaPesquisa
  alias ModuloPesquisa.Models.Midia
  alias ModuloPesquisa.Models.Midia.Categoria
  alias ModuloPesquisa.Models.Midia.Tag
  alias ModuloPesquisa.Models.NucleoPesquisa
  alias ModuloPesquisa.Models.Pesquisador
  alias ModuloPesquisa.Models.RelatorioPesquisa

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

  def relatorio_factory do
    %RelatorioPesquisa{
      tipo: Enum.random(~w(mensal bimestral trimestral anual)),
      data_inicio: ~D[2023-01-01],
      data_fim: ~D[2023-02-15],
      data_entrega: ~D[2023-07-30],
      data_limite: ~D[2023-02-15],
      id_publico: Nanoid.generate_non_secure(),
      link: "https//datalake.com/relatorio",
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
