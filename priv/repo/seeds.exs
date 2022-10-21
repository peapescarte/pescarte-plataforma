alias Backend.Accounts
alias Backend.ResearchModulus

{:ok, city} = ResearchModulus.create_city(%{county: "Campos dos Goytacazes"})

{:ok, campus} =
  ResearchModulus.create_campus(%{
    name: "Universidade Estadual do Norte Fluminense Darcy Ribeiro",
    initials: "UENF",
    city_id: city.id
  })

{:ok, user} =
  Accounts.register_user(%{
    password: "gW3XS8(Eo*mY6/xl",
    password_confirmation: "gW3XS8(Eo*mY6/xl",
    first_name: "Zoey",
    middle_name: "de Souza",
    last_name: "Pessanha",
    birthdate: ~D[2001-07-27],
    cpf: "133.590.177-90",
    contact: %{
      email: "zoey.spessanha@outlook.com",
      address: "R. Conselheiro José Fernandes, 341 - Campos do Goytacazes",
      mobile: "(22)99839-9070"
    }
  })

{:ok, _researcher} =
  ResearchModulus.create_researcher(%{
    minibio: "Olá",
    bursary: "pesquisa",
    link_lattes: "https://github.com/zoedsoupe",
    campus_id: campus.id,
    user_id: user.id
  })

{:ok, user} =
  Accounts.register_user(%{
    password: "AnnaBackend!",
    password_confirmation: "AnnaBackend!",
    first_name: "Annabell",
    middle_name: "Del Real",
    last_name: "Tamariz",
    birthdate: ~D[1969-01-13],
    cpf: "214.047.038-96",
    contact: %{
      email: "annabell@uenf.br",
      address: "Av. Alberto Lamego 2000, Campos dos Goytacazes",
      mobile: "(22)99831-5575"
    }
  })

{:ok, _researcher} =
  ResearchModulus.create_researcher(%{
    minibio: """
    Possui graduação em Ciência da Computação - Universidad de la Habana (1992),
    Mestrado em Engenharia Elétrica e Computação pela Universidade Estadual de
    Campinas (1999) e Doutorado em Engenharia Elétrica na área de automação pela
    Universidade Estadual de Campinas (2005).
    """,
    bursary: "pesquisa",
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
    birthdate: ~D[1982-09-10],
    cpf: "014.246.816-93",
    contact: %{
      email: "giselebragabastos.backend@gmail.com",
      address: "Rua Cesário Alvin, 150, apto 403, bloco 3",
      mobile: "(32) 99124-1049"
    }
  })

{:ok, _researcher} =
  ResearchModulus.create_researcher(%{
    minibio: "Eu sou Gisele Braga....",
    bursary: "celetista",
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
    contact: %{
      email: "geraldotimoteo@gmail.com",
      address: "Av. Alberto Lamego, 637, Bloco 11, apart. 202, Bairro: Pq. Califórnia",
      mobile: "(22) 99779-4886"
    }
  })

{:ok, _researcher} =
  ResearchModulus.create_researcher(%{
    minibio: "Eu sou Geraldo, atualmente o coordenador técnico do PEA Backend....",
    bursary: "coordenador_tecnico",
    link_lattes: "http://lattes.cnpq.br/8720264659381887",
    campus_id: campus.id,
    user_id: user.id
  })

{:ok, city} = ResearchModulus.create_city(%{county: "Sorocaba"})

{:ok, _campus} =
  ResearchModulus.create_campus(%{
    name: "Universidade Federal de São Carlos",
    initials: "UFSCar",
    city_id: city.id
  })

{:ok, user} =
  Accounts.register_user(%{
    password: "s8mU8DcsgUnH&H",
    password_confirmation: "s8mU8DcsgUnH&H",
    first_name: "Sahudy",
    middle_name: "Montenegro",
    last_name: "González",
    birthdate: ~D[1972-06-16],
    cpf: "214.521.238-88",
    contact: %{
      email: "sahudy.montenegro@gmail.com",
      address: "UFSCar, Rod SP-264 KM 110, Sorocaba",
      mobile: "(15)98126-4233"
    }
  })

{:ok, _researcher} =
  ResearchModulus.create_researcher(%{
    minibio: """
    Graduada em Ciência da Computação pela Universidad de la Habana.
    Mestrado e Doutorado em Automação pela Universidade Estadual de Campinas
    """,
    bursary: "consultoria",
    link_lattes: "http://lattes.cnpq.br/9826346918182685",
    campus_id: campus.id,
    user_id: user.id
  })
