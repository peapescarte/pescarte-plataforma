defmodule FuschiaWeb.Swagger.NucleoSchemas do
  @moduledoc false

  require OpenApiSpex

  alias OpenApiSpex.Schema

  defmodule CreateRequest do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "Criação do Nucleo de Pesquisa",
      type: :object,
      properties: %{
        nome: %Schema{type: :string, description: "Nucleo name", required: true},
        descricao: %Schema{type: :string, description: "Nucleo description", required: true}
      },
      example: %{
        "nome" => "Núcleo Quissamã",
        "descricao" => "Núcleo resposável pela pesca"
      }
    })
  end

  defmodule AllNucleosResponse do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "Listagem de Núcleos de Pesquisa",
      type: :object,
      properties: %{
        data: %Schema{description: "Nucleo", type: :array, items: Nucleo}
      },
      example: %{
        "data" => [
          %{
            "nome" => "Núcleo Quissamã",
            "id_externo" => "1111111",
            "descricao" => "Núcleo resposável pela pesca"
          }
        ]
      }
    })
  end

  defmodule Nucleo do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "Nucleo info",
      type: :object,
      properties: %{
        nome: %Schema{type: :string, description: " Nucleo name"},
        id_externo: %Schema{type: :string, description: "Nucleo id"},
        descricao: %Schema{type: :string, description: "Nucleo description"}
      },
      example: %{
        "nome" => "Núcleo Quissamã",
        "id_externo" => "1111111",
        "descricao" => "Núcleo resposável pela pesca"
      }
    })
  end
end
