defmodule PescarteWeb.GraphQL.SchemaTest do
  use PescarteWeb.ConnCase, async: true

  import Pescarte.Factory

  @moduletag :integration

  setup :register_and_generate_user_token

  describe "login mutation" do
    @login_mutation """
    mutation Login($cpf: String!, $password: String!) {
      login(cpf: $cpf, senha: $password) {
        token
        usuario {
          dataNascimento
          id
          primeiroNome
          sobrenome
          cpf
          tipo
        }
      }
    }
    """

    test "quando o usuário não existe ou cpf/senha são inválidos", %{conn: conn} do
      conn =
        post(conn, "/api", %{
          "query" => @login_mutation,
          "variables" => %{"cpf" => "123", "password" => "123"}
        })

      assert %{
               "errors" => [
                 %{"message" => "Usuário não encontrado"}
               ]
             } = json_response(conn, 200)
    end

    test "quando cpf/senha são válidos", %{conn: conn, user: user} do
      conn =
        post(conn, "/api", %{
          "query" => @login_mutation,
          "variables" => %{"cpf" => user.cpf, "password" => senha_atual()}
        })

      assert %{"data" => %{"login" => %{"token" => _, "usuario" => logged}}} =
               json_response(conn, 200)

      assert logged["cpf"] == user.cpf
      assert logged["primeiroNome"] == user.primeiro_nome
      assert logged["sobrenome"] == user.sobrenome
      assert logged["dataNascimento"] == Date.to_string(user.data_nascimento)
    end
  end

  describe "listar usuários query" do
    @list_user_query """
    query ListUsuarios {
      listarUsuarios {
        id
        primeiroNome
        sobrenome
        tipo
      }
    }
    """

    test "quando não nenhum usuário", %{conn: conn} do
      conn = post(conn, "/api", %{"query" => @list_user_query})

      assert json_response(conn, 200) == %{"data" => []}
    end

    test "quando há um usuário", %{conn: conn} do
      conn = post(conn, "/api", %{"query" => @list_user_query})

      assert json_response(conn, 200) == %{}
    end
  end
end
