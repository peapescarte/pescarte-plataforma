defmodule FuschiaWeb.Swagger.ContatoSchemas do
  @moduledoc false

  require OpenApiSpex

  alias OpenApiSpex.Schema

  defmodule Contato do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "A user's contact info",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "Contact ID"},
        email: %Schema{type: :string, description: "Contact Email"},
        celular: %Schema{type: :string, description: "Contact Cellphone"},
        endereco: %Schema{type: :string, description: "Contact Address"}
      },
      example: %{
        "celular" => "11999999999",
        "email" => "teste@solfacil.com.br",
        "id" => 138,
        "endereco" => "Av. Teste João"
      }
    })
  end
end
