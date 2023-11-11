defmodule PescarteWeb.GraphQL.TagSchemaTest do
  use PescarteWeb.GraphQL.ConnCase, async: true

  import Pescarte.ModuloPesquisa.Factory

  @moduletag :integration

  describe "listar tags query" do
    setup :register_and_generate_jwt_token

    @list_tags_query """
    query ListarTags {
      listarTags {
        id
        etiqueta
        categoria {
          id
        }
      }
    }
    """

    test "quando não há nenhuma tag", %{conn: conn} do
      conn = post(conn, "/", %{"query" => @list_tags_query})

      assert %{"data" => %{"listarTags" => []}} = json_response(conn, 200)
    end

    test "quando há tag", %{conn: conn} do
      categoria = insert(:categoria)
      tag = insert(:tag, categoria_nome: categoria.nome)
      conn = post(conn, "/", %{"query" => @list_tags_query})

      assert %{"data" => %{"listarTags" => [listed]}} = json_response(conn, 200)
      assert listed["id"] == tag.id_publico
      assert listed["etiqueta"] == tag.etiqueta
      assert listed["categoria"]["id"] == categoria.id_publico
    end
  end

  describe "criar tag mutation" do
    setup :register_and_generate_jwt_token

    @create_tag_mutation """
    mutation CriarTag($input: CriarTagInput!) {
      criarTag(input: $input) {
        id
        etiqueta
        categoria {
          id
        }
      }
    }
    """

    test "quando os parâmetros são inválidos", %{conn: conn} do
      categoria = insert(:categoria)

      conn =
        post(conn, "/", %{
          "query" => @create_tag_mutation,
          "variables" => %{"input" => %{"etiqueta" => "", "categoriaId" => categoria.id_publico}}
        })

      assert %{"errors" => [error]} = json_response(conn, 200)
      assert error["code"] == "validation"
      assert error["status_code"] == 422
      assert error["key"] == "etiqueta"
    end

    test "quando os parâmetros são válidos", %{conn: conn} do
      categoria = insert(:categoria)
      params = %{"etiqueta" => "peixe", "categoriaId" => categoria.id_publico}

      conn =
        post(conn, "/", %{
          "query" => @create_tag_mutation,
          "variables" => %{
            "input" => params
          }
        })

      assert %{"data" => %{"criarTag" => created}} = json_response(conn, 200)
      assert created["etiqueta"] == params["etiqueta"]
      assert created["categoria"]["id"] == params["categoriaId"]
    end
  end

  describe "criar múltiplas tags mutation" do
    setup :register_and_generate_jwt_token

    @create_tags_mutation """
    mutation CriarTags($input: [CriarTagInput]) {
      criarTags(input: $input) {
        etiqueta
        id
      }
    }
    """

    test "quando os parâmetros são inválidos, apenas uma", %{conn: conn} do
      categoria = insert(:categoria)

      conn =
        post(conn, "/", %{
          "query" => @create_tags_mutation,
          "variables" => %{
            "input" => [%{"etiqueta" => "", "categoriaId" => categoria.id_publico}]
          }
        })

      assert %{"errors" => [error]} = json_response(conn, 200)
      assert error["code"] == "validation"
      assert error["status_code"] == 422
      assert error["key"] == "etiqueta"
    end

    test "quando os parâmetros de uma tag são inválidos, criando vários", %{conn: conn} do
      categoria = insert(:categoria)

      params = [
        %{"etiqueta" => "sol", "categoriaId" => categoria.id_publico},
        %{"etiqueta" => "", "categoriaId" => categoria.id_publico}
      ]

      conn =
        post(conn, "/", %{
          "query" => @create_tags_mutation,
          "variables" => %{"input" => params}
        })

      assert %{"errors" => [error]} = json_response(conn, 200)
      assert error["code"] == "validation"
      assert error["status_code"] == 422
      assert error["key"] == "etiqueta"
    end

    test "quando os parâmetros são válidos, criar várias", %{conn: conn} do
      categoria = insert(:categoria)

      params = [
        %{"etiqueta" => "sol", "categoriaId" => categoria.id_publico},
        %{"etiqueta" => "peixe", "categoriaId" => categoria.id_publico}
      ]

      conn =
        post(conn, "/", %{
          "query" => @create_tags_mutation,
          "variables" => %{"input" => params}
        })

      assert %{"data" => %{"criarTags" => created}} = json_response(conn, 200)
      assert length(created) == 2
    end

    test "quando os parâmetros de apenas uma tag são inváidos, ao tentar criar vários, 2 vezes",
         %{conn: conn} do
      categoria = insert(:categoria)

      params = [
        %{"etiqueta" => "sol", "categoriaId" => categoria.id_publico},
        %{"etiqueta" => "", "categoriaId" => categoria.id_publico}
      ]

      conn =
        post(conn, "/", %{
          "query" => @create_tags_mutation,
          "variables" => %{"input" => params}
        })

      assert %{"errors" => [error]} = json_response(conn, 200)
      assert error["code"] == "validation"
      assert error["status_code"] == 422
      assert error["key"] == "etiqueta"

      another_params = [
        %{"etiqueta" => "sol", "categoriaId" => categoria.id_publico},
        %{"etiqueta" => "peixe", "categoriaId" => categoria.id_publico}
      ]

      another_conn =
        post(conn, "/", %{
          "query" => @create_tags_mutation,
          "variables" => %{"input" => another_params}
        })

      assert %{"data" => %{"criarTags" => created}} = json_response(another_conn, 200)
      assert length(created) == 2
    end
  end

  describe "atualizar tag mutation" do
    setup :register_and_generate_jwt_token

    @update_tag_mutation """
    mutation AtualizarTag($input: AtualizarTagInput!) {
      atualizarTag(input: $input) {
        id
        etiqueta
      }
    }
    """

    test "quando os parâmetros são inválidos", %{conn: conn} do
      tag = insert(:tag)

      conn =
        post(conn, "/", %{
          "query" => @update_tag_mutation,
          "variables" => %{"input" => %{"etiqueta" => "", "id" => tag.id_publico}}
        })

      assert %{"errors" => [error]} = json_response(conn, 200)
      assert error["code"] == "validation"
      assert error["status_code"] == 422
      assert error["key"] == "etiqueta"
    end

    test "quando os parâmetros são válidos", %{conn: conn} do
      tag = insert(:tag)

      conn =
        post(conn, "/", %{
          "query" => @update_tag_mutation,
          "variables" => %{
            "input" => %{"etiqueta" => "sol", "id" => tag.id_publico}
          }
        })

      assert %{"data" => %{"atualizarTag" => updated}} = json_response(conn, 200)
      assert updated["etiqueta"] != tag.etiqueta
      assert updated["etiqueta"] == "sol"
    end
  end
end
