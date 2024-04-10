defmodule PescarteWeb.GraphQL.CategoriaSchemaTest do
  use PescarteWeb.ConnCase, async: true

  import Pescarte.Fixtures

  @moduletag :integration

  describe "listar categorias query" do
    setup :register_and_generate_jwt_token

    @list_categorias_query """
    query ListarCategorias {
      listarCategorias {
        id
        nome
        tags {
          id
          etiqueta
          categoria {
            id
          }
        }
      }
    }
    """

    test "quando não há nenhuma categoria", %{conn: conn} do
      conn = post(conn, "/api", %{"query" => @list_categorias_query})

      assert %{"data" => %{"listarCategorias" => []}} = json_response(conn, 200)
    end

    test "quando há categoria", %{conn: conn} do
      categoria = insert(:categoria)
      conn = post(conn, "/api", %{"query" => @list_categorias_query})

      assert %{"data" => %{"listarCategorias" => [listed]}} = json_response(conn, 200)
      assert listed["id"] == categoria.id
      assert listed["nome"] == categoria.nome
    end

    test "quando há categoria e nenhuma tag, recuperar tags vazia", %{conn: conn} do
      categoria = insert(:categoria)
      conn = post(conn, "/api", %{"query" => @list_categorias_query})

      assert %{"data" => %{"listarCategorias" => [listed]}} = json_response(conn, 200)
      assert listed["id"] == categoria.id
      assert listed["nome"] == categoria.nome
      assert Enum.empty?(listed["tags"])
    end
  end
end
