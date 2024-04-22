defmodule Seeder.Identidades.Usuario do
  alias Pescarte.Database.Repo
  alias Pescarte.Identidades.Models.Contato
  alias Pescarte.Identidades.Models.Usuario
  @behaviour Seeder.Entry

  defp contato_id_by(index: index) do
    contatos = Repo.all(Contato)
    Enum.at(contatos, index).id
  end

  @impl true
  def entries do
    [
      %Usuario{
        primeiro_nome: "Zoey",
        sobrenome: "de Souza Pessanha",
        data_nascimento: ~D[2001-07-27],
        cpf: Brcpfcnpj.cpf_generate(true),
        contato_id: contato_id_by(index: 0),
        papel: :admin,
        rg: "123456789"
      },
      %Usuario{
        primeiro_nome: "Annabell",
        sobrenome: "Del Real Tamariz",
        data_nascimento: ~D[1969-01-13],
        cpf: Brcpfcnpj.cpf_generate(true),
        contato_id: contato_id_by(index: 1),
        papel: :admin,
        rg: "123456789"
      },
      %Usuario{
        primeiro_nome: "Gisele Braga",
        sobrenome: "Bastos",
        data_nascimento: ~D[1982-09-10],
        cpf: Brcpfcnpj.cpf_generate(true),
        contato_id: contato_id_by(index: 2),
        papel: :admin,
        rg: "123456789"
      },
      %Usuario{
        primeiro_nome: "Geraldo",
        sobrenome: "Timóteo",
        data_nascimento: ~D[1966-09-25],
        cpf: Brcpfcnpj.cpf_generate(true),
        contato_id: contato_id_by(index: 3),
        papel: :pesquisador,
        rg: "123456789"
      },
      %Usuario{
        primeiro_nome: "Sahudy",
        sobrenome: "Montenegro González",
        data_nascimento: ~D[1972-06-16],
        cpf: Brcpfcnpj.cpf_generate(true),
        contato_id: contato_id_by(index: 4),
        papel: :admin,
        rg: "123456789"
      }
    ]
  end
end
