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
        cpf: "37472770710",
        contato_id: contato_id_by(index: 0),
        papel: :admin,
        rg: "123456789",
        external_customer_id: "supabase|" <> "ed31ec14-b4bc-4e24-a877-91fb8d0d2de4",
        link_avatar:
          "https://drive.google.com/file/d/1le-ipDAdzymf0X0LRvP2E5T7HP262Yip/view?usp=drive_link"
      },
      %Usuario{
        primeiro_nome: "Annabell",
        sobrenome: "Del Real Tamariz",
        data_nascimento: ~D[1969-01-13],
        cpf: "47420550638",
        contato_id: contato_id_by(index: 1),
        papel: :admin,
        rg: "123456789",
        external_customer_id: "supabase|" <> "8ecdf5e3-eba3-4dc8-a974-0427ebd10e59",
        link_avatar:
          "https://drive.google.com/file/d/1VbbvEw36djPzV1DKQwS-SBO07Qo__Tmp/view?usp=drive_link"
      },
      %Usuario{
        primeiro_nome: "Gisele Braga",
        sobrenome: "Bastos",
        data_nascimento: ~D[1982-09-10],
        cpf: "84906049915",
        contato_id: contato_id_by(index: 2),
        papel: :admin,
        rg: "123456789",
        external_customer_id: "supabase|" <> "89451354-c041-4bea-ab74-bd6fa9b2407b"
      },
      %Usuario{
        primeiro_nome: "Geraldo",
        sobrenome: "Timóteo",
        data_nascimento: ~D[1966-09-25],
        cpf: "83801575594",
        contato_id: contato_id_by(index: 3),
        papel: :pesquisador,
        rg: "123456789",
        external_customer_id: "supabase|" <> "cb4397a6-4206-4b36-af05-1518a22cea33",
        link_avatar:
          "https://drive.google.com/file/d/1gAeRzMWuSd7Ys75MvYdbUPJFzMCow_kJ/view?usp=drive_link"
      },
      %Usuario{
        primeiro_nome: "Sahudy",
        sobrenome: "Montenegro González",
        data_nascimento: ~D[1972-06-16],
        cpf: "37140748055",
        contato_id: contato_id_by(index: 4),
        papel: :admin,
        rg: "123456789",
        external_customer_id: "supabase|" <> "006019fe-10a2-4aa9-8c25-0407d09fbe43",
        link_avatar:
          "https://drive.google.com/file/d/1KIJ6E5XkfI0FJjsfDvxuHizNtbYArF_5/view?usp=drive_link"
      }
    ]
  end
end
