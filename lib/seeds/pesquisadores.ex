defmodule Seeds.Pesquisadores do
  alias Pescarte.Database
  alias Pescarte.Domains.Accounts
  alias Pescarte.Domains.ModuloPesquisa
  alias Pescarte.Domains.ModuloPesquisa.Models.Pesquisador

  def run do
    IO.puts("==> Running Pesquisadores seeds")

    Enum.each(pesquisadores(), &insert/1)
  end

  defp insert(attrs) do
    case ModuloPesquisa.get_pesquisador(link_lattes: attrs.link_lattes) do
      {:ok, _cidade} ->
        IO.puts("==> Pesquisador with lattes #{attrs.link_lattes} already exists")

      _ ->
        Pesquisador
        |> struct!(attrs)
        |> Database.insert!()
    end
  end

  defp pesquisadores do
    uenf = elem(ModuloPesquisa.get_campus(initials: "UENF"), 1).id

    user_id = fn cpf -> elem(Accounts.get_user(cpf: cpf), 1).id end

    [
      %{
        minibio: "Olá",
        bolsa: :pesquisa,
        link_lattes: "https://github.com/zoedsoupe",
        campus_id: uenf,
        user_id: user_id.("133.590.177-90"),
        public_id: Nanoid.generate()
      },
      %{
        minibio: """
        Possui graduação em Ciência da Computação - Universidad de la Habana (1992),
        Mestrado em Engenharia Elétrica e Computação pela Universidade Estadual de
        Campinas (1999) e Doutorado em Engenharia Elétrica na área de automação pela
        Universidade Estadual de Campinas (2005).
        """,
        bolsa: :pesquisa,
        link_lattes: "http://lattes.cnpq.br/7484786835288826",
        campus_id: uenf,
        user_id: user_id.("214.047.038-96"),
        public_id: Nanoid.generate()
      },
      %{
        minibio: "Eu sou Gisele Braga....",
        bolsa: :celetista,
        link_lattes: "http://lattes.cnpq.br/1675744772217864",
        campus_id: uenf,
        user_id: user_id.("014.246.816-93"),
        public_id: Nanoid.generate()
      },
      %{
        minibio: "Eu sou Geraldo, atualmente o coordenador técnico do PEA Pescarte....",
        bolsa: :coordenador_tecnico,
        link_lattes: "http://lattes.cnpq.br/8720264659381887",
        campus_id: uenf,
        user_id: user_id.("553.901.536-34"),
        public_id: Nanoid.generate()
      },
      %{
        minibio: """
        Graduada em Ciência da Computação pela Universidad de la Habana.
        Mestrado e Doutorado em Automação pela Universidade Estadual de Campinas
        """,
        bolsa: :consultoria,
        link_lattes: "http://lattes.cnpq.br/9826346918182685",
        campus_id: elem(ModuloPesquisa.get_campus(initials: "UFSCar"), 1).id,
        user_id: user_id.("214.521.238-88"),
        public_id: Nanoid.generate()
      }
    ]
  end
end
