defmodule FuschiaWeb.Swagger.CidadeSchemas do
  @moduledoc false

  require OpenApiSpex

  alias OpenApiSpex.Schema

  defmodule CreateRequest do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "Criação da Cidade",
      type: :object,
      properties: %{
        municipio: %Schema{type: :string, description: "Municipio name", required: true}
      },
      example: %{
        "municipio" => "Campos dos Goytacazes"
      }
    })
  end

  defmodule AllCidadesResponse do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "Listagem de Cidade",
      type: :object,
      properties: %{
        data: %Schema{description: "Cidades", type: :array, items: Cidade}
      },
      example: %{
        "data" => [
          %{
            "municipio" => "Campos dos Goytacazes",
            "id_externo" => "1111111"
          }
        ]
      }
    })
  end

  defmodule Cidade do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "Informaçoes das cidades",
      type: :object,
      properties: %{
        municipio: %Schema{type: :string, description: "Municipio name"},
        id_externo: %Schema{type: :string, description: "Cidade id"}
      },
      example: %{
        "municipio" => "Campos dos Goytacazes",
        "id_externo" => "1111111"
      }
    })
  end
end
