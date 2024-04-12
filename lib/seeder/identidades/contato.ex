defmodule Seeder.Identidades.Contato do
  alias Pescarte.Identidades.Models.Contato
  @behaviour Seeder.Entry

  @impl true
  def entries do
    [
      %Contato{
        email_principal: Faker.Internet.safe_email(),
        endereco: Faker.Address.street_address(true),
        celular_principal: Faker.Phone.PtBr.phone()
      },
      %Contato{
        email_principal: Faker.Internet.safe_email(),
        endereco: Faker.Address.street_address(true),
        celular_principal: Faker.Phone.PtBr.phone()
      },
      %Contato{
        email_principal: Faker.Internet.safe_email(),
        endereco: Faker.Address.street_address(true),
        celular_principal: Faker.Phone.PtBr.phone()
      },
      %Contato{
        email_principal: Faker.Internet.safe_email(),
        endereco: Faker.Address.street_address(true),
        celular_principal: Faker.Phone.PtBr.phone()
      },
      %Contato{
        email_principal: Faker.Internet.safe_email(),
        endereco: Faker.Address.street_address(true),
        celular_principal: Faker.Phone.PtBr.phone()
      }
    ]
  end
end
