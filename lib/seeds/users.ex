defmodule Seeds.Users do
  alias Pescarte.Domains.Accounts

  def run do
    IO.puts("==> Running Users seeds")

    Enum.each(users(), &insert/1)
  end

  defp insert(attrs) do
    case Accounts.get_user(first_name: attrs.first_name) do
      {:ok, _cidade} ->
        IO.puts("==> User with name #{attrs.first_name} already exists")

      _ ->
        Accounts.register_user(attrs)
    end
  end

  defp users do
    [
      %{
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
      },
      %{
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
      },
      %{
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
      },
      %{
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
      },
      %{
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
      }
    ]
  end
end
