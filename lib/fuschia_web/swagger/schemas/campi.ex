defmodule FuschiaWeb.Swagger.CampusSchemas do
  @moduledoc false

  require OpenApiSpex

  alias OpenApiSpex.Schema

  defmodule CreateRequest do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "Criação do Campus",
      type: :object,
      properties: %{
        nome: %Schema{type: :string, description: "Campus name", required: true}
      },
      example: %{
        "nome" => "Campos dos Goytacazes"
      }
    })
  end

  defmodule AllCampiResponse do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "Listagem de Campi",
      type: :object,
      properties: %{
        data: %Schema{description: "Campi", type: :array, items: Campus}
      },
      example: %{
        "data" => [
          %{
            "nome" => "Campos dos Goytacazes",
            "id_externo" => "1111111"
          }
        ]
      }
    })
  end

  defmodule Campus do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "Campus info",
      type: :object,
      properties: %{
        nome: %Schema{type: :string, description: "Campus name"},
        id_externo: %Schema{type: :string, description: "Campus id"}
      },
      example: %{
        "nome" => "Campos dos Goytacazes",
        "id_externo" => "1111111"
      }
    })
  end
end
