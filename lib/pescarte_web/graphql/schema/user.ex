defmodule PescarteWeb.GraphQL.Schema.User do
  @moduledoc false

  use Absinthe.Schema.Notation

  import AbsintheErrorPayload.Payload

  alias PescarteWeb.GraphQL.Resolvers

  # Queries

  payload_object(:listagem_usuarios, list_of(:usuario))

  object :usuario_queries do
    @desc "Listagem de usuários"
    field :listar_usuarios, type: :listagem_usuarios do
      resolve(&Resolvers.User.list/2)
      middleware(&build_payload/2)
    end
  end

  # Mutations

  @desc "Parâmetros para criar um acesso de usuário"
  input_object :login_input do
    field :cpf, non_null(:string)
    field :senha, non_null(:string)
  end

  payload_object(:login_payload, :login)

  object :usuario_mutations do
    @desc "Cria um acesso para um usuário"
    field :login, type: :login_payload do
      arg(:input, :login_input)

      resolve(&Resolvers.Login.resolve/2)
    end
  end
end
