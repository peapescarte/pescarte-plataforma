defmodule FuschiaWeb.Swagger.AuthSchemas do
  @moduledoc false

  require OpenApiSpex

  alias FuschiaWeb.Swagger.ContatoSchemas
  alias OpenApiSpex.Schema

  defmodule Login do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "POST body for Login",
      security: [
        %{"api_key_header" => []},
        %{"api_key_query" => []}
      ],
      type: :object,
      properties: %{
        cpf: %Schema{type: :string, description: "User CPF"},
        password: %Schema{type: :string, description: "User Password", format: "password"}
      },
      required: [:cpf, :password],
      example: %{
        "cpf" => "123.456.789-12",
        "password" => "123456"
      }
    })
  end

  defmodule Signup do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "POST body for Signup",
      type: :object,
      properties: %{
        dataNascimento: %Schema{type: :string, format: :date, description: "User Birthday"},
        nomeCompleto: %Schema{type: :string, description: "User full name"},
        contato: ContatoSchemas.Contato,
        cpf: %Schema{type: :string, description: "User CPF"},
        password: %Schema{type: :string, description: "User Password", format: "password"},
        passwordConfirmation: %Schema{
          type: :string,
          description: "User Password Confirmation",
          format: "password"
        }
      },
      required: [:contato, :password, :cpf, :passwordConfirmation, :dataNascimento],
      example: %{
        "dataNascimento" => "2001-07-27",
        "nomeCompleto" => "Joãozinho Testinho",
        "contato" => %{
          "email" => "teste@uenf.com.br",
          "celular" => "+55 (71) 99999-9999",
          "endereco" => "Av. Teste João, 123"
        },
        "password" => "201763",
        "passwordConfirmation" => "201763",
        "perfil" => "admin"
      }
    })
  end

  defmodule UsuarioClaim do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "User Data",
      description: "User Data Claim",
      type: :object,
      properties: %{
        dataNascimento: %Schema{type: :string, format: :date, description: "User Birthday"},
        cpf: %Schema{type: :string, description: "User CPF"},
        email: %Schema{type: :string, description: "User Email"},
        endereco: %Schema{type: :string, description: "User Address"},
        celular: %Schema{type: :string, description: "User Mobile"},
        nomeCompleto: %Schema{type: :string, description: "User Full Name"},
        perfil: %Schema{
          type: :string,
          description: "User's profile",
          enum: ["avulso", "admin", "pesquisador", "pescador"]
        },
        permissoes: %Schema{description: "User Permissions", type: :object}
      }
    })
  end

  defmodule Token do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "Token",
      description: "Auth Token",
      type: :object,
      properties: %{
        token: %Schema{type: :string, description: "JWT Token"}
      }
    })
  end

  defmodule TokenWithUserClaim do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "Token with User Claims",
      description: "Data Structure with Auth Token and User Claims",
      type: :object,
      properties: %{
        user: UsuarioClaim,
        token: Token
      }
    })
  end

  defmodule LoginRequest do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "LoginRequest",
      description: "POST body for user login",
      type: :object,
      properties: %{
        cpf: %Schema{type: :string, description: "User CPF"},
        password: %Schema{type: :string, description: "User Password", format: "password"}
      },
      required: [:cpf, :password],
      example: %{
        "cpf" => "123.456.789-12",
        "password" => "123456"
      }
    })
  end

  defmodule LoginResponse do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "LoginResponse",
      description: "Response schema for Login",
      type: :object,
      properties: %{
        data: TokenWithUserClaim
      },
      example: %{
        "data" => %{
          "user" => %{
            "dataNasc" => "2021-07-27",
            "cpf" => "999.999.999-99",
            "email" => "teste@pescarte.com.br",
            "endereco" => "Av. Teste João, 123",
            "celular" => "(22)12345-6789",
            "nomeCompleto" => "Joãozinho Testinho",
            "perfil" => "pesquisador",
            "permissoes" => %{
              "relatorio" => ["read", "write"]
            },
            "token" =>
              "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJhdWQiOiJzb2xmYWNpbF92MSIsImV4cCI6MTYwMzM4ODIzOCwiaWF0IjoxNjAzMTI5MDM4LCJpc3MiOiJzb2xmYWNpbF92MSIsImp0aSI6ImU1Y2YwZmQzLTQ4MTYtNGQ5OC05MWViLWRjZTFmZDQwYTI2NyIsIm5iZiI6MTYwMzEyOTAzNywic3ViIjoiNiIsInR5cCI6ImFjY2VzcyJ9.eQcZphC32O-oKSmz4ivysDVps4WqMOG6I3H7CHS__2ER_oAxgT1CetmjKaQnIvblfSLpuwDAe7zTlY3VvfkzrQ"
          }
        }
      }
    })
  end
end
