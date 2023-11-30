defmodule Seeder.Identidades.Usuario do
  alias Pescarte.Identidades.Models.Usuario
  @behaviour Seeder.Entry

  defp hash_senha do
    Bcrypt.hash_pwd_salt("Senha!123")
  end

  @impl true
  def entries do
    [
      %Usuario{
        id_publico: Nanoid.generate_non_secure(),
        hash_senha: hash_senha(),
        primeiro_nome: "Zoey",
        sobrenome: "de Souza Pessanha",
        data_nascimento: ~D[2001-07-27],
        confirmado_em: ~N[2023-06-23 03:43:08],
        cpf: "13359017790",
        contato_email: "zoey.spessanha@outlook.com",
        tipo: :admin
      },
      %Usuario{
        id_publico: Nanoid.generate_non_secure(),
        hash_senha: hash_senha(),
        primeiro_nome: "Annabell",
        sobrenome: "Del Real Tamariz",
        confirmado_em: ~N[2023-06-23 03:43:08],
        data_nascimento: ~D[1969-01-13],
        cpf: "21404703896",
        contato_email: "annabell@uenf.br",
        tipo: :admin
      },
      %Usuario{
        id_publico: Nanoid.generate_non_secure(),
        hash_senha: hash_senha(),
        primeiro_nome: "Gisele Braga",
        sobrenome: "Bastos",
        confirmado_em: ~N[2023-06-23 03:43:08],
        data_nascimento: ~D[1982-09-10],
        cpf: "01424681693",
        contato_email: "giselebragabastos.pescarte@gmail.com",
        tipo: :admin
      },
      %Usuario{
        id_publico: Nanoid.generate_non_secure(),
        hash_senha: hash_senha(),
        primeiro_nome: "Geraldo",
        sobrenome: "Timóteo",
        data_nascimento: ~D[1966-09-25],
        confirmado_em: ~N[2023-06-23 03:43:08],
        cpf: "55390153634",
        contato_email: "geraldotimoteo@gmail.com",
        tipo: :pesquisador
      },
      %Usuario{
        id_publico: Nanoid.generate_non_secure(),
        hash_senha: hash_senha(),
        primeiro_nome: "Sahudy",
        sobrenome: "Montenegro González",
        data_nascimento: ~D[1972-06-16],
        confirmado_em: ~N[2023-06-23 03:43:08],
        cpf: "21452123888",
        contato_email: "sahudy.montenegro@gmail.com",
        tipo: :admin
      }
    ]
  end
end
