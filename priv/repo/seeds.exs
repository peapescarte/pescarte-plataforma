alias Pescarte.Domains.Accounts
alias Pescarte.Domains.ModuloPesquisa

{:ok, cidade} = ModuloPesquisa.create_cidade(%{county: "Campos dos Goytacazes"})

{:ok, campus} =
  ModuloPesquisa.create_campus(%{
    name: "Universidade Estadual do Norte Fluminense Darcy Ribeiro",
    initials: "UENF",
    cidade_id: cidade.id
  })

{:ok, user} =
  Accounts.register_user(%{
    password: "gW3XS8(Eo*mY6/xl",
    password_confirmation: "gW3XS8(Eo*mY6/xl",
    first_name: "Zoey",
    middle_name: "de Souza",
    last_name: "Pessanha",
    birthdate: ~D[2001-07-27],
    confirmed_at: NaiveDateTime.utc_now(),
    cpf: "133.590.177-90",
    contato: %{
      email: "zoey.spessanha@outlook.com",
      address: "R. Conselheiro José Fernandes, 341 - Campos do Goytacazes",
      mobile: "(22)99839-9070"
    }
  })

{:ok, zoey} =
  ModuloPesquisa.create_pesquisador(%{
    minibio: "Olá",
    bolsa: :pesquisa,
    link_lattes: "https://github.com/zoedsoupe",
    campus_id: campus.id,
    user_id: user.id
  })

{:ok, user} =
  Accounts.register_user(%{
    password: "AnnaPescarte!",
    password_confirmation: "AnnaPescarte!",
    first_name: "Annabell",
    middle_name: "Del Real",
    last_name: "Tamariz",
    confirmed_at: NaiveDateTime.utc_now(),
    birthdate: ~D[1969-01-13],
    cpf: "214.047.038-96",
    contato: %{
      email: "annabell@uenf.br",
      address: "Av. Alberto Lamego 2000, Campos dos Goytacazes",
      mobile: "(22)99831-5575"
    }
  })

{:ok, _pesquisador} =
  ModuloPesquisa.create_pesquisador(%{
    minibio: """
    Possui graduação em Ciência da Computação - Universidad de la Habana (1992),
    Mestrado em Engenharia Elétrica e Computação pela Universidade Estadual de
    Campinas (1999) e Doutorado em Engenharia Elétrica na área de automação pela
    Universidade Estadual de Campinas (2005).
    """,
    bolsa: :pesquisa,
    link_lattes: "http://lattes.cnpq.br/7484786835288826",
    campus_id: campus.id,
    user_id: user.id
  })

{:ok, user} =
  Accounts.register_user(%{
    password: "hMmMRL7Ds&59M!",
    password_confirmation: "hMmMRL7Ds&59M!",
    first_name: "Gisele",
    middle_name: "Braga",
    last_name: "Bastos",
    confirmed_at: NaiveDateTime.utc_now(),
    birthdate: ~D[1982-09-10],
    cpf: "014.246.816-93",
    contato: %{
      email: "giselebragabastos.pescarte@gmail.com",
      address: "Rua Cesário Alvin, 150, apto 403, bloco 3",
      mobile: "(32) 99124-1049"
    }
  })

{:ok, _pesquisador} =
  ModuloPesquisa.create_pesquisador(%{
    minibio: "Eu sou Gisele Braga....",
    bolsa: :celetista,
    link_lattes: "http://lattes.cnpq.br/1675744772217864",
    campus_id: campus.id,
    user_id: user.id
  })

{:ok, user} =
  Accounts.register_user(%{
    password: "dsZx&2ZR74qZ#6",
    password_confirmation: "dsZx&2ZR74qZ#6",
    first_name: "Geraldo",
    last_name: "Timóteo",
    birthdate: ~D[1966-09-25],
    cpf: "553.901.536-34",
    confirmed_at: NaiveDateTime.utc_now(),
    contato: %{
      email: "geraldotimoteo@gmail.com",
      address: "Av. Alberto Lamego, 637, Bloco 11, apart. 202, Bairro: Pq. Califórnia",
      mobile: "(22) 99779-4886"
    }
  })

{:ok, _pesquisador} =
  ModuloPesquisa.create_pesquisador(%{
    minibio: "Eu sou Geraldo, atualmente o coordenador técnico do PEA Pescarte....",
    bolsa: :coordenador_tecnico,
    link_lattes: "http://lattes.cnpq.br/8720264659381887",
    campus_id: campus.id,
    user_id: user.id
  })

{:ok, cidade} = ModuloPesquisa.create_cidade(%{county: "Sorocaba"})

{:ok, _campus} =
  ModuloPesquisa.create_campus(%{
    name: "Universidade Federal de São Carlos",
    initials: "UFSCar",
    cidade_id: cidade.id
  })

{:ok, user} =
  Accounts.register_user(%{
    password: "s8mU8DcsgUnH&H",
    password_confirmation: "s8mU8DcsgUnH&H",
    first_name: "Sahudy",
    middle_name: "Montenegro",
    last_name: "González",
    birthdate: ~D[1972-06-16],
    confirmed_at: NaiveDateTime.utc_now(),
    cpf: "214.521.238-88",
    contato: %{
      email: "sahudy.montenegro@gmail.com",
      address: "UFSCar, Rod SP-264 KM 110, Sorocaba",
      mobile: "(15)98126-4233"
    }
  })

{:ok, _pesquisador} =
  ModuloPesquisa.create_pesquisador(%{
    minibio: """
    Graduada em Ciência da Computação pela Universidad de la Habana.
    Mestrado e Doutorado em Automação pela Universidade Estadual de Campinas
    """,
    bolsa: :consultoria,
    link_lattes: "http://lattes.cnpq.br/9826346918182685",
    campus_id: campus.id,
    user_id: user.id
  })

for name <- ["autoral", "local", "conteudo", "eventos"] do
  {:ok, categoria} = ModuloPesquisa.create_categoria(%{name: name})

  case name do
    "autoral" ->
      {:ok, tag} =
        ModuloPesquisa.create_tag(%{
          label: "fulano_da_silva",
          categoria_id: categoria.id
        })

    "conteudo" ->
      tags =
        for label <- ~w(redes peixes mar barco) do
          {:ok, tag} =
            ModuloPesquisa.create_tag(%{
              label: label,
              categoria_id: categoria.id
            })

          tag
        end

      {:ok, _} =
        ModuloPesquisa.create_midia(%{
          tags: tags,
          filename: "IMG20230126.png",
          type: :imagem,
          filedate: Date.utc_today(),
          pesquisador_id: zoey.id,
          link: "https://drive.google.com/uc?export=view&id=1YqVklE01-XPX-6iAO0iYie5acOCk0rhk"
        })

    _ ->
      nil
  end
end
