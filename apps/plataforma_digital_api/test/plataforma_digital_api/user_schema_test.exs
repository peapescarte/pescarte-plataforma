defmodule PlataformaDigitalAPI.UserSchemaTest do
  use PlataformaDigitalAPI.ConnCase, async: true

  @moduletag :integration

  describe "listar usuários query" do
    setup :register_and_generate_jwt_token

    @list_user_query """
    query ListartUsuarios {
      listarUsuarios {
        id
        primeiroNome
        sobrenome
        tipo
        cpf
      }
    }
    """

    test "quando não há nenhum usuário adicional", %{conn: conn} do
      conn = post(conn, "/", %{"query" => @list_user_query})

      assert %{"data" => %{"listarUsuarios" => users}} = json_response(conn, 200)
      assert length(users) == 1
    end

    test "quando há um usuário", %{conn: conn} do
      user = Identidades.Factory.insert(:usuario)
      conn = post(conn, "/", %{"query" => @list_user_query})

      assert %{"data" => %{"listarUsuarios" => [_, listed]}} = json_response(conn, 200)
      assert listed["cpf"] == user.cpf
    end
  end
end
