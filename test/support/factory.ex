defmodule Pescarte.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Pescarte.Repo

  alias Pescarte.Domains.Accounts.Models.Contato
  alias Pescarte.Domains.Accounts.Models.User
  alias Pescarte.Domains.Accounts.Models.UserToken
  alias Pescarte.Domains.ModuloPesquisa.Models.Campus
  alias Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag
  alias Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioAnual
  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioMensal
  alias Pescarte.Domains.ModuloPesquisa.Models.RelatorioTrimestral

  def campus_factory do
    %Campus{
      id_publico: Nanoid.generate_non_secure(),
      nome: sequence(:nome, &"Campus #{&1}"),
      endereco_id: insert(:endereco).id,
      acronimo: sequence(:sigla, &"C#{&1 + 1}")
    }
  end

  def categoria_factory do
    %Categoria{
      id_publico: Nanoid.generate_non_secure(),
      nome: sequence("nome")
    }
  end

  def contato_factory do
    %Contato{
      email_principal: sequence(:email, &"test-#{&1}@example.com"),
      celular_principal: sequence(:celular, &"221245167#{digit_rem(&1 + 1)}"),
      emails_adicionais: sequence_list(:emails, &"test-#{&1}@example.com", limit: 3),
      celulares_adicionais: sequence_list(:celulares, &"221234567#{digit_rem(&1)}", limit: 4),
      endereco_id: insert(:endereco).id
    }
  end

  def endereco_factory do
    alias Pescarte.Domains.Accounts.Models.Endereco

    %Endereco{
      cep: "00000000",
      cidade: sequence("Cidade"),
      complemento: "Um complemento",
      estado: "Rio de Janeiro",
      numero: 100,
      rua: "Rua Exemplo de Queiras"
    }
  end

  def linha_pesquisa_factory do
    %LinhaPesquisa{
      id_publico: Nanoid.generate_non_secure(),
      numero: sequence(:numero, Enum.to_list(1..21)),
      desc_curta: sequence(:descricao_curta, &"Descricao LinhaPesquisa Curta #{&1}"),
      desc: sequence(:descricao_longa, &"Descricao LinhaPesquisa Longa #{&1}"),
      nucleo_pesquisa_id: insert(:nucleo_pesquisa).id,
      responsavel_lp_id: insert(:pesquisador).id,
      pesquisadores: insert_list(1, :pesquisador)
    }
  end

  def midia_factory do
    %Midia{
      id_publico: Nanoid.generate_non_secure(),
      autor_id: insert(:user).id,
      tipo: sequence(:tipo, ["video", "documento", "imagem"]),
      link: sequence(:link, &"https://example#{&1}.com"),
      nome_arquivo: sequence(:arquivo, &"arquivo#{&1}.jpg"),
      data_arquivo: ~D[2023-05-29],
      restrito?: false
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
      usuario_id: insert(:user).id,
      minibio: sequence(:minibiografia, &"Esta e minha minibiografia gerada: #{&1}"),
      bolsa: sequence(:tipo_bolsa, ["ic", "pesquisa", "voluntario"]),
      link_lattes: sequence(:link_lattes, &"http://buscatextual.cnpq.br/buscatextual/:#{&1}"),
      campus_id: insert(:campus).id,
      data_inicio_bolsa: ~D[2023-05-26],
      data_contratacao: ~D[2023-04-23],
      data_fim_bolsa: ~D[2024-05-30],
      formacao: "Advogado",
      rg: "131213465",
      link_linkedin: "https://linkedin.com/in/zoedsoupe",
      orientador: orientador()
    }
  end

  defp orientador do
    %Pesquisador{
      id_publico: Nanoid.generate_non_secure(),
      usuario: %User{
        id_publico: Nanoid.generate_non_secure(),
        tipo: "pesquisador",
        primeiro_nome: "José",
        sobrenome: "Caldas",
        cpf: Brcpfcnpj.cpf_generate(),
        hash_senha: "$2b$12$VbolDic21AxNGu8W2jbTd.6pxqwv9d4m4UpR/2rP8s3Qd/UO.6mTO",
        contato_id: insert(:contato).id,
        data_nascimento: ~D[1990-03-27]
      },
      bolsa: "pesquisa",
      minibio: "hello",
      rg: "141113465",
      link_lattes: "https://lattes.com.br",
      link_linkedin: "https://linkedin.com",
      campus: %Campus{
        acronimo: sequence("ABCD"),
        id_publico: Nanoid.generate_non_secure(),
        endereco_id: insert(:endereco).id
      }
    }
  end

  def relatorio_anual_factory do
    %RelatorioAnual{
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
      ano: 2023,
      mes: 4,
      link: "https//datalake.com/relatorio_anual",
      pesquisador_id: insert(:pesquisador).id,
      status: :pendente
    }
  end

  def relatorio_mensal_factory do
    %RelatorioMensal{
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
      pesquisador_id: insert(:pesquisador).id,
      status: :pendente
    }
  end

  def relatorio_trimestral_factory do
    %RelatorioTrimestral{
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
      pesquisador_id: insert(:pesquisador).id,
      status: :pendente
    }
  end

  def tag_factory do
    %Tag{
      id_publico: Nanoid.generate_non_secure(),
      etiqueta: sequence("etiqueta"),
      categoria_id: insert(:categoria).id
    }
  end

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "Hello World 42!"

  def user_factory do
    %User{
      id_publico: Nanoid.generate_non_secure(),
      tipo: sequence(:role, ["admin", "pesquisador"]),
      primeiro_nome: sequence(:first, &"User #{&1}"),
      sobrenome: sequence(:last, &"Last User #{&1}"),
      cpf: Brcpfcnpj.cpf_generate(),
      data_nascimento: Date.utc_today(),
      hash_senha: "$2b$12$6beq5zEplVZjji7Jm7itJuTXd3wH9rDN.V5VRcaS/A8YJ28mi1LBG",
      contato_id: insert(:contato).id,
      senha: "Password!123"
    }
  end

  def user_creation_factory do
    user = build(:user)
    user |> Map.from_struct() |> Map.put(:senha_confirmation, user.senha)
  end

  def email_token_factory do
    context = sequence(:contexto, ["confirm", "reset_password"])
    token = :crypto.strong_rand_bytes(32)
    hashed = :crypto.hash(:sha256, token)
    contato = insert(:contato)
    user = insert(:user, contato_id: contato.id)

    %UserToken{
      contexto: context,
      usuario_id: user.id,
      enviado_para: contato.email_principal,
      token: hashed
    }
  end

  def session_token_factory do
    contato = insert(:contato)
    user = insert(:user, contato_id: contato.id)

    %UserToken{
      contexto: "session",
      usuario_id: user.id,
      enviado_para: contato.email_principal,
      token: :crypto.strong_rand_bytes(32)
    }
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.url, "[TOKEN]")
    token
  end

  def senha_atual do
    "Password!123"
  end

  # Convenience API

  def fixture(factory) do
    factory |> build() |> Map.from_struct()
  end

  defp sequence_list(label, custom, opts) do
    limit = Keyword.get(opts, :limit, 1)

    sequences =
      for _ <- 1..limit do
        sequence(label, custom)
      end

    if limit > 1, do: sequences, else: hd(sequences)
  end

  defp digit_rem(digit) do
    (digit < 10 && "#{digit}#{digit - 1}") || digit + 1
  end
end
