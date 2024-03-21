defmodule Seeder.ModuloPesquisa.Pesquisador do
  alias Pescarte.Database.Repo.Replica
  alias Pescarte.Identidades.Models.Usuario
  alias Pescarte.ModuloPesquisa.Models.Pesquisador
  @behaviour Seeder.Entry

  defp usuario_id_by_cpf(cpf) do
    usuario = Replica.get_by!(Usuario, cpf: cpf)
    usuario.id
  end

  @impl true
  def entries do
    [
      %Pesquisador{
        minibio: "Olá",
        bolsa: :pesquisa,
        link_lattes: "https://github.com/zoedsoupe",
        # campus_acronimo: "UENF",
        usuario_id: usuario_id_by_cpf("13359017790"),
        link_banner_perfil: "/images/peixinhos.svg",
        id: Nanoid.generate_non_secure()
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
        link_linkedin: "www.linkedin.com/in/annabell-d-r-tamariz-89565629a",
        # campus_acronimo: "UENF",
        usuario_id: usuario_id_by_cpf("21404703896"),
        link_banner_perfil: "/images/peixinhos.svg",
        id: Nanoid.generate_non_secure()
      },
      %Pesquisador{
        minibio: "Eu sou Gisele Braga....",
        bolsa: :celetista,
        link_lattes: "http://lattes.cnpq.br/1675744772217864",
        # campus_acronimo: "UENF",
        usuario_id: usuario_id_by_cpf("01424681693"),
        id: Nanoid.generate_non_secure()
      },
      %Pesquisador{
        minibio: "Eu sou Geraldo, atualmente o coordenador técnico do PEA Pescarte....",
        bolsa: :coordenador_tecnico,
        link_lattes: "http://lattes.cnpq.br/8720264659381887",
        # campus_acronimo: "UENF",
        usuario_id: usuario_id_by_cpf("55390153634"),
        id: Nanoid.generate_non_secure()
      },
      %Pesquisador{
        minibio: """
        Graduada em Ciência da Computação pela Universidad de la Habana.
        Mestrado e Doutorado em Automação pela Universidade Estadual de Campinas
        """,
        bolsa: :consultoria,
        link_lattes: "http://lattes.cnpq.br/9826346918182685",
        # campus_acronimo: "UFSCar",
        usuario_id: usuario_id_by_cpf("21452123888"),
        id: Nanoid.generate_non_secure()
      }
    ]
  end
end
