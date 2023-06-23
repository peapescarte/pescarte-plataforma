defmodule ContatoSeed do
  alias Pescarte.Domains.Accounts.Models.Contato

  def entries do
    [
      %Contato{
        email_principal: "zoey.spessanha@outlook.com",
        endereco_cep: "28013602",
        celular_principal: "(22)99839-9070",
        id_publico: Nanoid.generate_non_secure()
      },
      %Contato{
        email_principal: "annabell@uenf.br",
        endereco_cep: "28013602",
        celular_principal: "(22)99831-5575",
        id_publico: Nanoid.generate_non_secure()
      },
      %Contato{
        email_principal: "giselebragabastos.pescarte@gmail.com",
        endereco_cep: "28013602",
        celular_principal: "(32) 99124-1049",
        id_publico: Nanoid.generate_non_secure()
      },
      %Contato{
        email_principal: "geraldotimoteo@gmail.com",
        endereco_cep: "28013602",
        celular_principal: "(22) 99779-4886",
        id_publico: Nanoid.generate_non_secure()
      },
      %Contato{
        email_principal: "sahudy.montenegro@gmail.com",
        endereco_cep: "13565905",
        celular_principal: "(15)98126-4233",
        id_publico: Nanoid.generate_non_secure()
      }
    ]
  end
end
