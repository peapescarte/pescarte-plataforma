defmodule Seeder.ModuloPesquisa.Pesquisador do
  alias Pescarte.Database.Repo.Replica
  alias Pescarte.Identidades.Models.Usuario
  alias Pescarte.ModuloPesquisa.Models.Campus
  alias Pescarte.ModuloPesquisa.Models.LinhaPesquisa
  alias Pescarte.ModuloPesquisa.Models.Pesquisador

  @behaviour Seeder.Entry

  defp usuario_id_by(index: index) do
    usuarios = Replica.all(Usuario)
    Enum.at(usuarios, index).id
  end

  defp campus_id_by(index: index) do
    campus = Replica.all(Campus)
    Enum.at(campus, index).id
  end

  defp linha_pesquisa_id_by(numero: numero) do
    Replica.get_by!(LinhaPesquisa, numero: numero).id
  end

  @impl true
  def entries do
    [
      %Pesquisador{
        minibio: "Olá",
        bolsa: :pesquisa,
        link_lattes: "https://github.com/zoedsoupe",
        usuario_id: usuario_id_by(index: 0),
        link_banner_perfil: "/images/peixinhos.svg",
        campus_id: campus_id_by(index: 0),
        linha_pesquisa_principal_id: linha_pesquisa_id_by(numero: 1)
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
        usuario_id: usuario_id_by(index: 1),
        link_banner_perfil: "/images/peixinhos.svg",
        campus_id: campus_id_by(index: 0),
        linha_pesquisa_principal_id: linha_pesquisa_id_by(numero: 2)
      },
      %Pesquisador{
        minibio: "Eu sou Gisele Braga....",
        bolsa: :celetista,
        link_lattes: "http://lattes.cnpq.br/1675744772217864",
        usuario_id: usuario_id_by(index: 2),
        campus_id: campus_id_by(index: 0),
        linha_pesquisa_principal_id: linha_pesquisa_id_by(numero: 3)
      },
      %Pesquisador{
        minibio: "Eu sou Geraldo, atualmente o coordenador técnico do PEA Pescarte....",
        bolsa: :coordenador_tecnico,
        link_lattes: "http://lattes.cnpq.br/8720264659381887",
        usuario_id: usuario_id_by(index: 3),
        campus_id: campus_id_by(index: 0),
        linha_pesquisa_principal_id: linha_pesquisa_id_by(numero: 4)
      },
      %Pesquisador{
        minibio: """
        Graduada em Ciência da Computação pela Universidad de la Habana.
        Mestrado e Doutorado em Automação pela Universidade Estadual de Campinas
        """,
        bolsa: :consultoria,
        link_lattes: "http://lattes.cnpq.br/9826346918182685",
        usuario_id: usuario_id_by(index: 4),
        campus_id: campus_id_by(index: 1),
        linha_pesquisa_principal_id: linha_pesquisa_id_by(numero: 1)
      }
    ]
  end
end
