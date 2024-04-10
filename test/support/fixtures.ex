defmodule Pescarte.Fixtures do
  use ExMachina.Ecto, repo: Pescarte.Database.Repo

  alias Pescarte.Cotacoes.Models.Cotacao
  alias Pescarte.Cotacoes.Models.CotacaoPescado
  alias Pescarte.Cotacoes.Models.Fonte
  alias Pescarte.Cotacoes.Models.Pescado

  alias Pescarte.Identidades.Models.Contato
  alias Pescarte.Identidades.Models.Token
  alias Pescarte.Identidades.Models.Usuario

  alias Pescarte.ModuloPesquisa.Models.Campus
  alias Pescarte.ModuloPesquisa.Models.LinhaPesquisa
  alias Pescarte.ModuloPesquisa.Models.Midia
  alias Pescarte.ModuloPesquisa.Models.Midia.Categoria
  alias Pescarte.ModuloPesquisa.Models.Midia.Tag
  alias Pescarte.ModuloPesquisa.Models.NucleoPesquisa
  alias Pescarte.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.ModuloPesquisa.Models.RelatorioPesquisa

  def cotacao_factory do
    %Cotacao{
      id: Nanoid.generate_non_secure(8),
      data: ~D[2023-05-07],
      fonte_id: insert(:fonte).id,
      link: sequence(:link, &"https://example#{&1}.com/file.pdf"),
      importada?: false,
      baixada?: false,
      tipo: :pdf
    }
  end

  def cotacao_pescado_factory do
    cotacao = insert(:cotacao)

    %CotacaoPescado{
      id: Nanoid.generate_non_secure(8),
      cotacao_id: cotacao.id,
      fonte_id: insert(:fonte).id,
      pescado_id: insert(:pescado).id,
      preco_minimo: 1000,
      preco_maximo: 2000,
      preco_medio: 1500,
      preco_mais_comum: 1750
    }
  end

  def fonte_factory do
    %Fonte{
      id: Nanoid.generate_non_secure(8),
      nome: sequence("fonte"),
      link: sequence(:link, &"https://example#{&1}.com"),
      descricao: sequence("descricao")
    }
  end

  def pescado_factory do
    %Pescado{
      id: Nanoid.generate_non_secure(8),
      codigo: sequence("codigo_pescado"),
      embalagem: sequence("embalagem"),
      descricao: sequence("descricao"),
      inserted_at: DateTime.utc_now(),
      updated_at: DateTime.utc_now()
    }
  end

  def fixture(name) do
    %mod{} = struct = build(name)
    fields = mod.__schema__(:fields)

    struct
    |> Map.from_struct()
    |> Map.take(fields)
  end

  def contato_factory do
    %Contato{
      email_principal: sequence(:email, &"test-#{&1}@example.com"),
      celular_principal: sequence(:celular, &"221245167#{digit_rem(&1 + 1)}"),
      emails_adicionais: sequence_list(:emails, &"test-#{&1}@example.com", limit: 3),
      celulares_adicionais: sequence_list(:celulares, &"221234567#{digit_rem(&1)}", limit: 4),
      endereco: Faker.Address.street_address(true)
    }
  end

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "Hello World 42!"

  def usuario_factory do
    %Usuario{
      id: Nanoid.generate_non_secure(8),
      rg: sequence(:rg, &"131213465#{&1}"),
      papel: sequence(:role, ["admin", "pesquisador"]),
      primeiro_nome: sequence(:first, &"User #{&1}"),
      sobrenome: sequence(:last, &"Last User #{&1}"),
      cpf: Brcpfcnpj.cpf_generate(true),
      data_nascimento: Date.utc_today(),
      hash_senha: "$2b$12$6beq5zEplVZjji7Jm7itJuTXd3wH9rDN.V5VRcaS/A8YJ28mi1LBG",
      contato_id: insert(:contato).id,
      senha: senha_atual()
    }
  end

  def usuario_creation_factory do
    user = build(:usuario)
    user |> Map.from_struct() |> Map.put(:senha_confirmation, user.senha)
  end

  def email_token_factory do
    context = sequence(:contexto, ["confirm", "reset_password"])
    token = :crypto.strong_rand_bytes(32)
    hashed = :crypto.hash(:sha256, token)
    contato = insert(:contato)
    user = insert(:usuario, contato_id: contato.id)

    %Token{
      contexto: context,
      usuario_id: user.id,
      enviado_para: contato.email_principal,
      token: hashed
    }
  end

  def session_token_factory do
    contato = insert(:contato)
    user = insert(:usuario, contato_id: contato.id)

    %Token{
      contexto: "session",
      usuario_id: user.id,
      enviado_para: contato.email_principal,
      token: :crypto.strong_rand_bytes(32)
    }
  end

  def senha_atual do
    "Password!123"
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

  def campus_factory do
    %Campus{
      id: Nanoid.generate_non_secure(8),
      nome: sequence(:nome, &"Campus #{&1}"),
      endereco: Faker.Address.street_address(true),
      acronimo: sequence(:sigla, &"C#{&1 + 1}"),
      nome_universidade: sequence(:nome, &"U#{&1 + 1}")
    }
  end

  def categoria_factory do
    %Categoria{
      id: Nanoid.generate_non_secure(8),
      nome: sequence("nome")
    }
  end

  def linha_pesquisa_factory do
    %LinhaPesquisa{
      id: Nanoid.generate_non_secure(8),
      numero: sequence(:numero, Enum.to_list(1..21)),
      desc_curta: sequence(:descricao_curta, &"Descricao LinhaPesquisa Curta #{&1}"),
      desc: sequence(:descricao_longa, &"Descricao LinhaPesquisa Longa #{&1}"),
      nucleo_pesquisa_id: insert(:nucleo_pesquisa).id,
      pesquisadores: insert_list(1, :pesquisador)
    }
  end

  def midia_factory do
    %Midia{
      id: Nanoid.generate_non_secure(8),
      autor_id: insert(:usuario).id,
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
      id: Nanoid.generate_non_secure(8),
      nome: sequence(:name, &"Nucleo #{&1}"),
      desc: sequence(:desc, &"Descricao Nucleo #{&1}"),
      letra: sequence(:letra, &String.upcase("A#{&1}"))
    }
  end

  def pesquisador_factory do
    %Pesquisador{
      id: Nanoid.generate_non_secure(8),
      usuario_id: insert(:usuario).id,
      minibio: sequence(:minibiografia, &"Esta e minha minibiografia gerada: #{&1}"),
      bolsa: sequence(:tipo_bolsa, ["ic", "pesquisa", "voluntario"]),
      link_lattes: sequence(:link_lattes, &"http://buscatextual.cnpq.br/buscatextual/:#{&1}"),
      campus_id: insert(:campus).id,
      data_inicio_bolsa: ~D[2023-05-26],
      data_contratacao: ~D[2023-04-23],
      data_fim_bolsa: ~D[2024-05-30],
      formacao: "Advogado",
      link_linkedin: "https://linkedin.com/in/zoedsoupe"
    }
  end

  def relatorio_factory do
    %RelatorioPesquisa{
      id: Nanoid.generate_non_secure(8),
      tipo: Enum.random(~w(mensal bimestral trimestral anual)),
      data_inicio: ~D[2023-01-01],
      data_fim: ~D[2023-02-15],
      data_entrega: ~D[2023-07-30],
      data_limite: ~D[2023-02-15],
      link: "https//datalake.com/relatorio",
      conteudo_mensal: %{},
      pesquisador_id: insert(:pesquisador).id,
      status: :pendente
    }
  end

  def tag_factory do
    %Tag{
      id: Nanoid.generate_non_secure(8),
      etiqueta: sequence("etiqueta"),
      categoria_id: insert(:categoria).id
    }
  end
end
