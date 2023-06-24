defmodule PlataformaDigitalAPI.CategoriaSchemaTest do
  use PlataformaDigitalAPI.ConnCase, async: true

  import ModuloPesquisa.Factory

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
      conn = post(conn, "/", %{"query" => @list_categorias_query})

      assert %{"data" => %{"listarCategorias" => []}} = json_response(conn, 200)
    end

    test "quando há categoria", %{conn: conn} do
      categoria = insert(:categoria)
      conn = post(conn, "/", %{"query" => @list_categorias_query})

      assert %{"data" => %{"listarCategorias" => [listed]}} = json_response(conn, 200)
      assert listed["id"] == categoria.id_publico
      assert listed["nome"] == categoria.nome
    end

    test "quando há categoria e nenhuma tag, recuperar tags vazia", %{conn: conn} do
      categoria = insert(:categoria)
      conn = post(conn, "/", %{"query" => @list_categorias_query})

      assert %{"data" => %{"listarCategorias" => [listed]}} = json_response(conn, 200)
      assert listed["id"] == categoria.id_publico
      assert listed["nome"] == categoria.nome
      assert Enum.empty?(listed["tags"])
    end

    test "quando há categoria e há tags, recuperar tags", %{conn: conn} do
      categoria = insert(:categoria)
      tag = insert(:tag, categoria_nome: categoria.nome)
      conn = post(conn, "/", %{"query" => @list_categorias_query})

      assert %{"data" => %{"listarCategorias" => [listed]}} = json_response(conn, 200)
      assert listed["id"] == categoria.id_publico
      assert listed["nome"] == categoria.nome

      [tag_listed] = listed["tags"]
      assert tag_listed["id"] == tag.id_publico
      assert tag_listed["etiqueta"] == tag.etiqueta
      assert tag_listed["categoria"]["id"] == categoria.id_publico
    end
  end
end
