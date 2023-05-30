defmodule Pescarte.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Pescarte.Repo

  alias Pescarte.Domains.Accounts.Models.UserToken
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Categoria
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag
  alias Pescarte.Domains.Accounts.Models.Contato
  alias Pescarte.Domains.Accounts.Models.User
  alias Pescarte.Domains.ModuloPesquisa.Models.Campus
  alias Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  def campus_factory do
    %Campus{
      id_publico: Nanoid.generate_non_secure(),
      nome: sequence(:nome, &"Campus #{&1}"),
      endereco_id: insert(:endereco).id,
      acronimo: sequence(:sigla, &"C#{&1}")
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
      celular_principal: sequence(:celular, &"221245167#{digit_rem(&1)}"),
      emails_adicionais: sequence_list(:emails, &"test-#{&1}@example.com", limit: 3),
      celulares_adicionais: sequence_list(:celulares, &"221234567#{digit_rem(&1)}", limit: 4),
      endereco: build(:endereco)
    }
  end

  def endereco_factory do
    alias Pescarte.Domains.Accounts.Models.Endereco

    %Endereco{
      cep: "00000000",
      cidade: "Campos dos Goytacazes",
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
      responsavel_lp_id: insert(:pesquisador).id
    }
  end

  def midia_factory do
    %Midia{
      id_publico: Nanoid.generate_non_secure(),
      autor: build(:user),
      tipo: sequence(:tipo, ["video", "documento", "imagem"]),
      link: sequence(:link, &"https://example#{&1}.com"),
      tags: [insert(:tag)],
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
      usuario: build(:user),
      minibio: sequence(:minibiografia, &"Esta e minha minibiografia gerada: #{&1}"),
      bolsa: sequence(:tipo_bolsa, ["ic", "pesquisa", "voluntario"]),
      link_lattes: sequence(:link_lattes, &"http://buscatextual.cnpq.br/buscatextual/:#{&1}"),
      campus: build(:campus),
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
        contato: build(:contato),
        data_nascimento: ~D[1990-03-27]
      },
      bolsa: "pesquisa",
      minibio: "hello",
      rg: "141113465",
      link_lattes: "https://lattes.com.br",
      link_linkedin: "https://linkedin.com",
      campus: %Campus{
        acronimo: "ABCD",
        id_publico: Nanoid.generate_non_secure(),
        endereco: build(:endereco)
      }
    }
  end

  def tag_factory do
    %Tag{
      id_publico: Nanoid.generate_non_secure(),
      etiqueta: sequence("etiqueta"),
      categoria: build(:categoria)
    }
  end

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "Hello World 42!"

  def user_factory do
    %User{
      id_publico: Nanoid.generate_non_secure(),
      tipo: sequence(:role, ["avulso", "pesquisador"]),
      primeiro_nome: sequence(:first, &"User #{&1}"),
      sobrenome: sequence(:last, &"Last User #{&1}"),
      cpf: Brcpfcnpj.cpf_generate(),
      data_nascimento: Date.utc_today(),
      hash_senha: "$2b$12$AZdxCkw/Rb5AlI/5S7Ebb.hIyG.ocs18MGkHAW2gdZibH7a1wHTyu",
      contato_id: insert(:contato).id
    }
  end

  def user_token_factory do
    context = sequence(:contexto, ["session", "confirm", "reset_password"])

    token =
      if context == "session" do
        :crypto.strong_rand_bytes(32)
      else
        token = :crypto.strong_rand_bytes(32)
        :crypto.hash(:sha256, token)
      end

    %UserToken{
      contexto: context,
      usuario_id: insert(:user).id,
      enviado_para: "test@example.com",
      token: token
    }
  end

  def user_fixture(opts \\ []) do
    :user
    |> Pescarte.Factory.insert(opts)
    |> Pescarte.Repo.preload([:contato, :pesquisador])
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.url, "[TOKEN]")
    token
  end

  # Convenience API

  defp sequence_list(label, custom, opts) do
    limit = Keyword.get(opts, :limit, 1)

    sequences =
      for _ <- 1..limit do
        sequence(label, custom)
      end

    if limit > 1, do: sequences, else: hd(sequences)
  end

  defp digit_rem(digit) do
    (digit < 10 && "#{digit}0") || digit
  end
end
