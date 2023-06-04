defmodule PescarteWeb.GraphQL.Types.Auth do
  use Absinthe.Schema.Notation

  enum :user_tipo do
    value(:pesquisador)
    value(:pescador)
    value(:admin)
  end

  object :user do
    field :cpf, :string
    field :data_nascimento, :date
    field :tipo, :user_tipo
    field :primeiro_nome, :string
    field :sobrenome, :string
    field :id_publico, :string, name: "id"
  end

  object :login do
    field :token, :string
    field :user, :user
  end
end
