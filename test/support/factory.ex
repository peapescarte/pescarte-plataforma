defmodule Fuschia.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Fuschia.Repo

  alias Fuschia.Accounts.Models.AuthLog
  alias Fuschia.Accounts.Models.Contato
  alias Fuschia.Accounts.Models.User, as: UserModel
  alias Fuschia.Accounts.Queries.User, as: UserQueries
  alias Fuschia.Database
  alias Fuschia.ModuloPesquisa.Models.Campus
  alias Fuschia.ModuloPesquisa.Models.Cidade
  alias Fuschia.ModuloPesquisa.Models.LinhaPesquisa
  alias Fuschia.ModuloPesquisa.Models.Midia
  alias Fuschia.ModuloPesquisa.Models.Nucleo
  alias Fuschia.ModuloPesquisa.Models.Pesquisador
  alias Fuschia.ModuloPesquisa.Models.Relatorio

  def auth_log_factory do
    user_agent =
      "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36"

    %AuthLog{
      ip: "127.0.0.1",
      user_agent: user_agent,
      user_id: Nanoid.generate_non_secure()
    }
  end

  def campus_factory do
    cidade = insert(:cidade)

    %Campus{
      id: Nanoid.generate_non_secure(),
      nome: sequence(:nome, &"Campus #{&1}"),
      cidade: cidade,
      sigla: sequence(:sigla, &"C#{&1}")
    }
  end

  def cidade_factory do
    %Cidade{
      id: Nanoid.generate_non_secure(),
      municipio: sequence(:municipio, &"Cidade #{&1}")
    }
  end

  def contato_factory do
    %Contato{
      email: sequence(:email, &"test-#{&1}@example.com"),
      celular: sequence(:celular, ["(22)12345-6789"]),
      endereco: sequence(:endereco, &"Teste, Rua teste, número #{&1}")
    }
  end

  def linha_pesquisa_factory do
    nucleo = insert(:nucleo)

    %LinhaPesquisa{
      id: Nanoid.generate_non_secure(),
      numero: sequence(:numero, Enum.to_list(1..21)),
      descricao_curta: sequence(:descricao_curta, &"Descricao LinhaPesquisa Curta #{&1}"),
      descricao_longa: sequence(:descricao_longa, &"Descricao LinhaPesquisa Longa #{&1}"),
      nucleo_id: nucleo.id
    }
  end

  def midia_factory do
    pesquisador = insert(:pesquisador)

    %Midia{
      id: Nanoid.generate_non_secure(),
      pesquisador: pesquisador,
      tipo: sequence(:tipo, ["video", "documento", "imagem"]),
      link: sequence(:link, &"https://example#{&1}.com"),
      tags: []
    }
  end

  def nucleo_factory do
    %Nucleo{
      id: Nanoid.generate_non_secure(),
      nome: sequence(:name, &"Nucleo #{&1}"),
      desc: sequence(:desc, &"Descricao Nucleo #{&1}")
    }
  end

  def pesquisador_factory do
    campus = insert(:campus)
    user = build(:user)

    %Pesquisador{
      id: Nanoid.generate_non_secure(),
      user: user,
      minibiografia: sequence(:minibiografia, &"Esta e minha minibiografia gerada: #{&1}"),
      tipo_bolsa: sequence(:tipo_bolsa, ["ic", "pesquisa", "voluntario"]),
      link_lattes: sequence(:link_lattes, &"http://buscatextual.cnpq.br/buscatextual/:#{&1}"),
      campus_id: campus.id
    }
  end

  def relatorio_factory do
    pesquisador = insert(:pesquisador)

    %Relatorio{
      id: Nanoid.generate_non_secure(),
      pesquisador: pesquisador,
      tipo: sequence(:tipo, ["mensal", "trimestral", "anual"]),
      link: sequence(:link, &"https://example#{&1}.com"),
      ano: Date.utc_today().year,
      mes: Date.utc_today().month
    }
  end

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "Hello World 42!"

  @spec user_factory :: User.t()
  def user_factory do
    %UserModel{
      id: Nanoid.generate_non_secure(),
      role: sequence(:role, ["avulso", "pesquisador"]),
      nome_completo: sequence(:nome_completo, &"User #{&1}"),
      ativo?: true,
      cpf: Brcpfcnpj.cpf_generate(true),
      data_nascimento: sequence(:data_nascimento, [~D[2001-07-27], ~D[2001-07-28]]),
      password_hash: "$2b$12$AZdxCkw/Rb5AlI/5S7Ebb.hIyG.ocs18MGkHAW2gdZibH7a1wHTyu",
      contato: build(:contato)
    }
  end

  def user_fixture(opts \\ []) do
    :user
    |> Fuschia.Factory.insert(opts)
    |> Database.preload_all(UserQueries.relationships())
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.url, "[TOKEN]")
    token
  end
end
