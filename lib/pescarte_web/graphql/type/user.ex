defmodule PescarteWeb.GraphQL.Type.User do
  use Absinthe.Schema.Notation

  @desc "Os possíveis tipo de um usuário"
  enum :tipo_usuario_enum do
    value(:pesquisador)
    value(:pescador)
    value(:admin)
  end

  @desc "Um usuário da plataforma PEA Pescarte"
  object :usuario do
    field(:cpf, :string, description: "O número do CPF de um usuário")
    field(:data_nascimento, :date, description: "A data de nascimento de um usuário")
    field(:tipo, :tipo_usuario_enum, description: "O tipo de um usuário")
    field(:primeiro_nome, :string, description: "O primeiro nome de um usuário")
    field(:sobrenome, :string, description: "O sobrenome de um usuário")
    field(:id, :string, name: "id", description: "O identificador de um usuário")
  end

  @desc "Representa um acesso de um usuário"
  object :login do
    field(:token, :string, description: "O token de acesso de um usuário")
    field(:usuario, :usuario, description: "O usuário que obteve acesso")
  end
end
