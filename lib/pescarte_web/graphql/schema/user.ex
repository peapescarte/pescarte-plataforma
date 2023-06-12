defmodule PescarteWeb.GraphQL.Schema.User do
  @moduledoc false

  use Absinthe.Schema.Notation

  alias PescarteWeb.GraphQL.Resolver

  # Queries

  object :usuario_queries do
    @desc "Listagem de usuários"
    field :listar_usuarios, list_of(:usuario) do
      resolve(&Resolver.User.list/2)
    end
  end

  # Mutations

  @desc "Parâmetros para criar um acesso de usuário"
  input_object :login_input do
    field :cpf, non_null(:string)
    field :senha, non_null(:string)
  end

  object :usuario_mutations do
    @desc "Cria um acesso para um usuário"
    field :login, :login do
      arg(:input, :login_input)

      resolve(&Resolver.Login.resolve/2)
    end
  end
end
