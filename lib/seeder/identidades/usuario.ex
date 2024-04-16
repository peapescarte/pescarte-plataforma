defmodule Seeder.Identidades.Usuario do
  alias Pescarte.Database.Repo
  alias Pescarte.Identidades.Models.Contato
  alias Pescarte.Identidades.Models.Usuario
  @behaviour Seeder.Entry

  defp hash_senha do
    Bcrypt.hash_pwd_salt("Senha!123")
  end

  defp contato_id_by(index: index) do
    contatos = Repo.all(Contato)
    Enum.at(contatos, index).id
  end

  @impl true
  def entries do
    [
      %Usuario{
        hash_senha: hash_senha(),
        primeiro_nome: "Zoey",
        sobrenome: "de Souza Pessanha",
        data_nascimento: ~D[2001-07-27],
        confirmado_em: ~N[2023-06-23 03:43:08],
        cpf: Brcpfcnpj.cpf_generate(true),
        contato_id: contato_id_by(index: 0),
        papel: :admin,
        rg: "123456789"
      },
      %Usuario{
        hash_senha: hash_senha(),
        primeiro_nome: "Annabell",
        sobrenome: "Del Real Tamariz",
        confirmado_em: ~N[2023-06-23 03:43:08],
        data_nascimento: ~D[1969-01-13],
        cpf: Brcpfcnpj.cpf_generate(true),
        contato_id: contato_id_by(index: 1),
        papel: :admin,
        rg: "123456789"
      },
      %Usuario{
        hash_senha: hash_senha(),
        primeiro_nome: "Gisele Braga",
        sobrenome: "Bastos",
        confirmado_em: ~N[2023-06-23 03:43:08],
        data_nascimento: ~D[1982-09-10],
        cpf: Brcpfcnpj.cpf_generate(true),
        contato_id: contato_id_by(index: 2),
        papel: :admin,
        rg: "123456789"
      },
      %Usuario{
        hash_senha: hash_senha(),
        primeiro_nome: "Geraldo",
        sobrenome: "Timóteo",
        data_nascimento: ~D[1966-09-25],
        confirmado_em: ~N[2023-06-23 03:43:08],
        cpf: Brcpfcnpj.cpf_generate(true),
        contato_id: contato_id_by(index: 3),
        papel: :pesquisador,
        rg: "123456789"
      },
      %Usuario{
        id: Nanoid.generate_non_secure(),
        hash_senha: hash_senha(),
        primeiro_nome: "Sahudy",
        sobrenome: "Montenegro González",
        data_nascimento: ~D[1972-06-16],
        confirmado_em: ~N[2023-06-23 03:43:08],
        cpf: Brcpfcnpj.cpf_generate(true),
        contato_id: contato_id_by(index: 4),
        papel: :admin,
        rg: "123456789"
      }
    ]
  end
end
