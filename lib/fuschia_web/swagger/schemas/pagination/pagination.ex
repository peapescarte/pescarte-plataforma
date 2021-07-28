defmodule FuschiaWeb.Swagger.PaginationSchemas do
  @moduledoc false

  require OpenApiSpex
  alias OpenApiSpex.Schema

  defmodule Pagination do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "Pagination",
      description: "Values used in pagination",
      type: :object,
      properties: %{
        afterCursor: %Schema{description: "key to next database page", type: :string},
        beforeCursor: %Schema{description: "key to previous database page", type: :string},
        size: %Schema{description: "Page size value", type: :integer},
        count: %Schema{description: "Total number of items", type: :integer}
      }
    })
  end
end
