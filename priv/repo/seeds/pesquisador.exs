defmodule PesquisadorSeed do
  alias Pescarte.Domains.Accounts.Models.Usuario
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador
  alias Pescarte.Repo

  defp usuario_id_by_cpf(cpf) do
    {:ok, usuario} = Repo.fetch_by(Usuario, cpf: cpf)
    usuario.id_publico
  end

  def entries do
    [
      %Pesquisador{
        minibio: "Olá",
        bolsa: :pesquisa,
        link_lattes: "https://github.com/zoedsoupe",
        campus_acronimo: "UENF",
        usuario_id: usuario_id_by_cpf("133.590.177-90"),
        id_publico: Nanoid.generate_non_secure()
      },
      %Pesquisador{
        minibio: """
        Possui graduação em Ciência da Computação - Universidad de la Habana (1992),
        Mestrado em Engenharia Elétrica e Computação pela Universidade Estadual de
        Campinas (1999) e Doutorado em Engenharia Elétrica na área de automação pela
        Universidade Estadual de Campinas (2005).
        """,
        bolsa: :pesquisa,
        link_lattes: "http://lattes.cnpq.br/7484786835288826",
        campus_acronimo: "UENF",
        usuario_id: usuario_id_by_cpf("214.047.038-96"),
        id_publico: Nanoid.generate_non_secure()
      },
      %Pesquisador{
        minibio: "Eu sou Gisele Braga....",
        bolsa: :celetista,
        link_lattes: "http://lattes.cnpq.br/1675744772217864",
        campus_acronimo: "UENF",
        usuario_id: usuario_id_by_cpf("014.246.816-93"),
        id_publico: Nanoid.generate_non_secure()
      },
      %Pesquisador{
        minibio: "Eu sou Geraldo, atualmente o coordenador técnico do PEA Pescarte....",
        bolsa: :coordenador_tecnico,
        link_lattes: "http://lattes.cnpq.br/8720264659381887",
        campus_acronimo: "UENF",
        usuario_id: usuario_id_by_cpf("553.901.536-34"),
        id_publico: Nanoid.generate_non_secure()
      },
      %Pesquisador{
        minibio: """
        Graduada em Ciência da Computação pela Universidad de la Habana.
        Mestrado e Doutorado em Automação pela Universidade Estadual de Campinas
        """,
        bolsa: :consultoria,
        link_lattes: "http://lattes.cnpq.br/9826346918182685",
        campus_acronimo: "UFSCar",
        usuario_id: usuario_id_by_cpf("214.521.238-88"),
        id_publico: Nanoid.generate_non_secure()
      }
    ]
  end
end
