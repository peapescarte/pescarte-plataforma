defmodule FuschiaWeb.Swagger.UserSchemas do
  @moduledoc false

  require OpenApiSpex

  alias OpenApiSpex.Schema

  defmodule User do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "An User",
      type: :object,
      properties: %{
        ativo: %Schema{type: :boolean, description: "Is User active?"},
        confirmado: %Schema{type: :boolean, description: "Is User confirmed?"},
        id: %Schema{type: :integer, description: "User ID"},
        email: %Schema{type: :string, description: "User Email"},
        cpf: %Schema{type: :string, description: "User CPF"},
        nomeCompleto: %Schema{type: :string, description: "User Name"},
        profile: %Schema{
          type: :string,
          description: "User's profile",
          enum: ["avulso", "admin", "pesquisador", "pescador"]
        },
        ultimoLogin: %Schema{type: :string, format: :"date-time"},
        dataNasc: %Schema{type: :string, format: :"date-time", description: "User Birthday"}
      },
      required: [:nomeCompleto, :perfil, :email, :ativo, :cpf, :dataNasc],
      example: %{
        "ativo" => true,
        "confirmado" => false,
        "email" => "teste@uenf.com.br",
        "id" => 30,
        "cpf" => "999.999.999-90",
        "nomeCompleto" => "Joãozinho Testinho",
        "perfil" => "avulso",
        "ultimoLogin" => nil,
        "dataNasc" => "2001-07-27"
      }
    })
  end

  defmodule UserResponse do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "UserResponse",
      description: "Response schema for single user",
      type: :object,
      properties: %{
        data: User
      },
      example: %{
        "data" => %{
          "ativo" => true,
          "confirmado" => false,
          "email" => "teste@uenf.com.br",
          "id" => 30,
          "nomeCompleto" => "Joãozinho Testinho",
          "cpf" => "999.999.999-99",
          "perfil" => "avulso",
          "ultimoLogin" => nil,
          "dataNasc" => "2001-07-27"
        }
      }
    })
  end

  defmodule UsersResponse do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "UsersResponse",
      description: "Response schema for multiple users",
      type: :object,
      properties: %{
        data: %Schema{description: "The users details", type: :array, items: User}
      },
      example: %{
        "data" => [
          %{
            "ativo" => true,
            "confirmado" => false,
            "email" => "teste@uenf.com.br",
            "id" => 30,
            "nomeCompleto" => "Joãozinho Testinho",
            "cpf" => "999.999.999-99",
            "perfil" => "avulso",
            "ultimoLogin" => nil,
            "dataNasc" => "2001-07-27"
          },
          %{
            "ativo" => true,
            "confirmado" => true,
            "email" => "admin.dev@example.com",
            "id" => 6,
            "nomeCompleto" => "Admin Dev",
            "cpf" => "123.456.789-10",
            "perfil" => "admin",
            "ultimoLogin" => "2020-09-28T22:27:27Z",
            "dataNasc" => "1990-08-07"
          }
        ]
      }
    })
  end

  defmodule UserRequest do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "UserRequest",
      description: "POST body for creating an user",
      type: :object,
      properties: %{
        nomeCompleto: %Schema{type: :string, description: "User Full Name"},
        email: %Schema{type: :string, description: "User Email"},
        cpf: %Schema{type: :string, description: "User CPF"},
        password: %Schema{type: :string, description: "User Password", format: "password"},
        perfil: %Schema{
          type: :string,
          description: "User's profile",
          enum: ["avulso", "admin", "pesquisador", "pescador"]
        }
      },
      required: [:nomeCompleto, :password, :perfil, :email, :cpf],
      example: %{
        "nomeCompleto" => "Joãozinho Testinho",
        "cpf" => "999.999.999-99",
        "email" => "teste@uenf.com.br",
        "password" => "201763",
        "perfil" => "admin"
      }
    })
  end

  defmodule UserSignupRequest do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "UserSignupRequest",
      description: "POST body for user sign-up",
      type: :object,
      properties: %{
        nomeCompleto: %Schema{type: :string, description: "User Full Name"},
        email: %Schema{type: :string, description: "User Email"},
        cpf: %Schema{type: :string, description: "User CPF"},
        password: %Schema{type: :string, description: "User Password", format: "password"},
        dataNasc: %Schema{type: :string, format: :"date-time", description: "User Birthday"}
      },
      required: [:nomeCompleto, :password, :email, :cpf, :dataNasc],
      example: %{
        "nomeCompleto" => "Joãozinho Testinho",
        "cpf" => "999.999.999-99",
        "password" => "201763",
        "email" => "teste@uenf.com.br",
        "dataNasc" => "2001-07-27"
      }
    })
  end
end
