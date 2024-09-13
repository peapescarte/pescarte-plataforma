defmodule Seeder.Identidades.Contato do
  alias Pescarte.Identidades.Models.Contato
  @behaviour Seeder.Entry

  @impl true
  def entries do
    [
      %Contato{
        email_principal: "dev.admin@pescarte.org.br",
        endereco: "943 Schuppe Row Suite 906",
        celular_principal: "(63) 5906-7216"
      },
      %Contato{
        email_principal: "dev.user@pescarte.org.br",
        endereco: "99981 Nicolas Orchard Apt. 060",
        celular_principal: "(62) 9 0254-9051"
      },
      %Contato{
        email_principal: "dev.user1@pescarte.org.br",
        endereco: "2 Shanny Shore Apt. 674",
        celular_principal: "(71) 3570-5710"
      },
      %Contato{
        email_principal: "dev.user2@pescarte.org.br",
        endereco: "74132 Alessandra Place Apt. 299",
        celular_principal: "(86) 9 4994-3367"
      },
      %Contato{
        email_principal: "dev.user3@pescarte.org.br",
        endereco: "6864 Suzanne Overpass Apt. 273",
        celular_principal: "(92) 4225-7846"
      }
    ]
  end
end
