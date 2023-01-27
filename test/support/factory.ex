defmodule Pescarte.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Pescarte.Repo

  alias Pescarte.Domains.Accounts.Models.Contato
  alias Pescarte.Domains.Accounts.Models.User
  alias Pescarte.Domains.ModuloPesquisa.Models.Campus
  alias Pescarte.Domains.ModuloPesquisa.Models.Cidade
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia
  alias Pescarte.Domains.ModuloPesquisa.Models.NucleoPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.Domains.ModuloPesquisa.Models.LinhaPesquisa

  def campus_factory do
    %Campus{
      public_id: Nanoid.generate_non_secure(),
      name: sequence(:nome, &"Campus #{&1}"),
      cidade: build(:cidade),
      initials: sequence(:sigla, &"C#{&1}")
    }
  end

  def cidade_factory do
    %Cidade{
      public_id: Nanoid.generate_non_secure(),
      county: sequence(:municipio, &"Cidade #{&1}")
    }
  end

  def contato_factory do
    %Contato{
      email: sequence(:email, &"test-#{&1}@example.com"),
      mobile: sequence(:celular, ["(22)12345-6789"]),
      address: sequence(:endereco, &"Teste, Rua teste, número #{&1}")
    }
  end

  def linha_pesquisa_factory do
    %LinhaPesquisa{
      public_id: Nanoid.generate_non_secure(),
      number: sequence(:numero, Enum.to_list(1..21)),
      short_desc: sequence(:descricao_curta, &"Descricao LinhaPesquisa Curta #{&1}"),
      desc: sequence(:descricao_longa, &"Descricao LinhaPesquisa Longa #{&1}"),
      nucleo_pesquisa_id: build(:nucleo_pesquisa)
    }
  end

  def midia_factory do
    %Midia{
      public_id: Nanoid.generate_non_secure(),
      pesquisador: build(:pesquisador),
      type: sequence(:tipo, ["video", "documento", "imagem"]),
      link: sequence(:link, &"https://example#{&1}.com")
    }
  end

  def nucleo_pesquisa_factory do
    %NucleoPesquisa{
      public_id: Nanoid.generate_non_secure(),
      name: sequence(:name, &"Nucleo #{&1}"),
      desc: sequence(:desc, &"Descricao Nucleo #{&1}")
    }
  end

  def pesquisador_factory do
    %Pesquisador{
      public_id: Nanoid.generate_non_secure(),
      user: build(:user),
      minibio: sequence(:minibiografia, &"Esta e minha minibiografia gerada: #{&1}"),
      bolsa: sequence(:tipo_bolsa, ["ic", "pesquisa", "voluntario"]),
      link_lattes: sequence(:link_lattes, &"http://buscatextual.cnpq.br/buscatextual/:#{&1}"),
      campus: build(:campus)
    }
  end

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "Hello World 42!"

  @spec user_factory :: User.t()
  def user_factory do
    %User{
      id: Nanoid.generate_non_secure(),
      role: sequence(:role, ["avulso", "pesquisador"]),
      first_name: sequence(:first, &"User #{&1}"),
      middle_name: sequence(:middle, &"Middle User #{&1}"),
      last_name: sequence(:last, &"Last User #{&1}"),
      cpf: Brcpfcnpj.cpf_generate(true),
      birthdate: Date.utc_today(),
      password_hash: "$2b$12$AZdxCkw/Rb5AlI/5S7Ebb.hIyG.ocs18MGkHAW2gdZibH7a1wHTyu",
      contato: build(:contato)
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
end
