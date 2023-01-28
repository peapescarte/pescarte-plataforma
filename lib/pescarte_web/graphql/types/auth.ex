defmodule PescarteWeb.GraphQL.Types.Auth do
  use Absinthe.Schema.Notation

  enum :role do
    value(:pesquisador)
    value(:pescador)
    value(:admin)
    value(:avulso)
  end

  object :user do
    field :cpf, :string
    field :birthdate, :date
    field :role, :role
    field :first_name, :string
    field :middle_name, :string
    field :last_name, :string
    field :public_id, :string, name: "id"
  end

  object :login do
    field :token, :string
    field :user, :user
  end
end
