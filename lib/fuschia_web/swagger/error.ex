defmodule FuschiaWeb.Swagger.Error do
  @moduledoc false

  require OpenApiSpex
  alias OpenApiSpex.Schema

  defmodule Unauthorized do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "Unauthorized",
      description: "Unauthorized access. Invalid/missing api key or jwt user token."
    })
  end

  defmodule Forbidden do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "Forbidden",
      description: "Access Denied. You don't have permission to access"
    })
  end

  defmodule ErrorMessage do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "ErrorBody",
      description: "Generic error body",
      type: :object,
      properties: %{
        error: %Schema{
          type: :object,
          properties: %{
            details: %Schema{type: :string, description: "Error message"}
          }
        }
      }
    })
  end

  defmodule ConflictMessage do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "ConflictErrorBody",
      description: "Conflict error body",
      type: :object,
      properties: %{
        details: %Schema{type: :string, description: "The item already exists"},
        resourceId: %Schema{type: :integer, description: "The item id"}
      }
    })
  end

  defmodule GenericError do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "Error",
      description: "Generic error message",
      type: :object,
      properties: %{
        error: ErrorMessage
      },
      example: %{
        "error" => %{
          "details" => "The item you requested doesn't exist"
        }
      }
    })
  end

  defmodule ConflictError do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "ConflictError",
      description: "Error message for conflicts ocurred when creating resources",
      type: :object,
      properties: %{
        error: ConflictMessage
      },
      example: %{
        "error" => %{
          "details" => "The item already exists",
          "resourceId" => 1
        }
      }
    })
  end
end
