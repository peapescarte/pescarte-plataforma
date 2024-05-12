defmodule Seeder.Identidades.Contato do
  alias Pescarte.Identidades.Models.Contato
  @behaviour Seeder.Entry

  @impl true
  def entries do
    [
      %Contato{
        email_principal: "dev.admin@pescarte.org.br",
        endereco: Faker.Address.street_address(true),
        celular_principal: Faker.Phone.PtBr.phone()
      },
      %Contato{
        email_principal: "dev.user@pescarte.org.br",
        endereco: Faker.Address.street_address(true),
        celular_principal: Faker.Phone.PtBr.phone()
      },
      %Contato{
        email_principal: "dev.user1@pescarte.org.br",
        endereco: Faker.Address.street_address(true),
        celular_principal: Faker.Phone.PtBr.phone()
      },
      %Contato{
        email_principal: "dev.user2@pescarte.org.br",
        endereco: Faker.Address.street_address(true),
        celular_principal: Faker.Phone.PtBr.phone()
      },
      %Contato{
        email_principal: "dev.user3@pescarte.org.br",
        endereco: Faker.Address.street_address(true),
        celular_principal: Faker.Phone.PtBr.phone()
      }
    ]
  end
end
