defmodule PlataformaDigitalAPI.LoginSchemaTest do
  use PlataformaDigitalAPI.ConnCase, async: true

  import Identidades.Factory

  @moduletag :integration

  describe "login mutation" do
    @login_mutation """
    mutation Login($input: LoginInput!) {
      login(input: $input) {
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

    @simple_list_query """
    query ListarUsuarios {
      listarUsuarios {
        id
      }
    }
    """

    test "quando o usuário não existe ou cpf/senha são inválidos", %{conn: conn} do
      conn =
        post(conn, "/", %{
          "query" => @login_mutation,
          "variables" => %{"input" => %{"cpf" => "123", "senha" => "123"}}
        })

      assert %{"errors" => [error]} = json_response(conn, 200)

      assert error["code"] == "not_found"
      assert error["status_code"] == 404
    end

    test "quando cpf/senha são válidos", %{conn: conn} do
      user = insert(:usuario)

      conn =
        post(conn, "/", %{
          "query" => @login_mutation,
          "variables" => %{"input" => %{"cpf" => user.cpf, "senha" => senha_atual()}}
        })

      assert %{"data" => %{"login" => %{"usuario" => logged}}} = json_response(conn, 200)

      assert logged["cpf"] == user.cpf
      assert logged["primeiroNome"] == user.primeiro_nome
      assert logged["sobrenome"] == user.sobrenome
      assert logged["dataNascimento"] == Date.to_string(user.data_nascimento)
    end

    test "quando não está autenticado, outras queries devem retornar erro", %{conn: conn} do
      conn = post(conn, "/", %{"query" => @simple_list_query})

      assert %{"errors" => [error]} = json_response(conn, 200)

      assert error["code"] == "unauthenticated"
      assert error["status_code"] == 401
    end
  end
end
