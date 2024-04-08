defmodule PescarteWeb.GraphQL.MidiaSchemaTest do
  use PescarteWeb.ConnCase, async: true

  import Pescarte.Fixtures

  alias Pescarte.ModuloPesquisa.Handlers.MidiasHandler

  @moduletag :integration

  describe "listar midias query" do
    setup :register_and_generate_jwt_token

    @list_midias_query """
    query {
      listarMidias {
        nomeArquivo
        id
        tags {
          id
          etiqueta
          categoria {
            id
            nome
          }
        }
        autor {
          id
          primeiroNome
        }
      }
    }
    """

    test "quando não há midia", %{conn: conn} do
      conn = post(conn, "/api", %{"query" => @list_midias_query})

      assert %{"data" => %{"listarMidias" => []}} = json_response(conn, 200)
    end

    test "quando há midias", %{conn: conn} do
      autor = insert(:usuario)
      categoria = insert(:categoria)
      tag = insert(:tag, categoria_id: categoria.id)
      midia = insert(:midia, autor_id: autor.id, tags: [tag])

      conn = post(conn, "/api", %{"query" => @list_midias_query})

      assert %{"data" => %{"listarMidias" => [listed]}} = json_response(conn, 200)
      assert listed["id"] == midia.id
      assert listed["nomeArquivo"] == midia.nome_arquivo
      assert listed["autor"]["id"] == autor.id

      [tag_listed] = listed["tags"]
      assert tag_listed["id"] == tag.id
      assert tag_listed["categoria"]["id"] == categoria.id
    end
  end

  describe "buscar uma midia" do
    setup :register_and_generate_jwt_token

    @get_midia_query """
    query BuscarMidia($id: String!) {
      buscarMidia(id: $id) {
        id
        nomeArquivo
        autor {
          id
        }
        tags {
          id
          etiqueta
          categoria {
            id
            nome
          }
        }
      }
    }
    """

    test "quando a midia não existe", %{conn: conn} do
      conn = post(conn, "/api", %{"query" => @get_midia_query, "variables" => %{"id" => "123"}})

      assert %{"errors" => [error]} = json_response(conn, 200)
      assert error["code"] == "not_found"
      assert error["status_code"] == 404
    end

    test "quando a mídia existe", %{conn: conn} do
      autor = insert(:usuario)
      categoria = insert(:categoria)
      tag = insert(:tag, categoria_id: categoria.id)
      midia = insert(:midia, autor_id: autor.id, tags: [tag])

      conn =
        post(conn, "/api", %{
          "query" => @get_midia_query,
          "variables" => %{"id" => midia.id}
        })

      assert %{"data" => %{"buscarMidia" => fetched}} = json_response(conn, 200)
      assert fetched["id"] == midia.id
      assert fetched["nomeArquivo"] == midia.nome_arquivo
      assert fetched["autor"]["id"] == autor.id

      [tag_listed] = fetched["tags"]
      assert tag_listed["id"] == tag.id
      assert tag_listed["categoria"]["id"] == categoria.id
    end
  end

  describe "criar midia mutation" do
    setup :register_and_generate_jwt_token

    @create_midia_mutation """
    mutation CriarMidia($input: CriarMidiaInput!) {
      criarMidia(input: $input) {
        id
        nomeArquivo
        autor {
          id
        }
        tags {
          id
          categoria {
            id
          }
        }
      }
    }
    """

    test "quando os parâmetros são inválidos", %{conn: conn} do
      conn =
        post(conn, "/api", %{
          "query" => @create_midia_mutation,
          "variables" => %{"input" => %{}}
        })

      assert %{"errors" => _} = json_response(conn, 200)
    end

    test "quando os parâmetros são válidos", %{conn: conn} do
      categoria = insert(:categoria)
      autor = insert(:usuario)

      params = %{
        "autorId" => autor.id,
        "nomeArquivo" => "imagem.png",
        "link" => "http://localhost:4000/imagem.png",
        "tipo" => "IMAGEM",
        "dataArquivo" => "2023-02-23",
        "tags" => [
          %{
            "etiqueta" => "um_teste",
            "categoriaId" => categoria.id
          },
          %{
            "etiqueta" => "outro_teste",
            "categoriaId" => categoria.id
          }
        ]
      }

      conn =
        post(conn, "/api", %{
          "query" => @create_midia_mutation,
          "variables" => %{"input" => params}
        })

      assert %{"data" => %{"criarMidia" => created}} = json_response(conn, 200)
      assert created["id"]
      assert created["nomeArquivo"] == params["nomeArquivo"]
      assert created["autor"]["id"] == autor.id
      assert length(created["tags"]) == 2
    end
  end

  describe "remove tags de midia mutation" do
    setup :register_and_generate_jwt_token

    @remove_midia_tags_mutation """
    mutation RemoveMidiaTags($input: RemoveTagInput!) {
      removeMidiaTags(input: $input) {
        id
        etiqueta
      }
    }
    """

    test "quando a mídia não existe", %{conn: conn} do
      conn =
        post(conn, "/api", %{
          "query" => @remove_midia_tags_mutation,
          "variables" => %{"input" => %{"midiaId" => "123", "tagsId" => []}}
        })

      assert %{"errors" => [error]} = json_response(conn, 200)
      assert error["code"] == "not_found"
      assert error["status_code"] == 404
    end

    test "quando nenhuma tag é removida", %{conn: conn} do
      midia = insert(:midia)

      assert Enum.empty?(midia.tags)

      conn =
        post(conn, "/api", %{
          "query" => @remove_midia_tags_mutation,
          "variables" => %{"input" => %{"midiaId" => midia.id, "tagsId" => []}}
        })

      assert %{"data" => %{"removeMidiaTags" => []}} = json_response(conn, 200)
    end

    test "quando a tag não existe", %{conn: conn} do
      midia = insert(:midia, tags: [])

      conn =
        post(conn, "/api", %{
          "query" => @remove_midia_tags_mutation,
          "variables" => %{"input" => %{"midiaId" => midia.id, "tagsId" => ["123"]}}
        })

      assert %{"data" => %{"removeMidiaTags" => []}} = json_response(conn, 200)
    end

    test "quando as tags existem", %{conn: conn} do
      tags = insert_list(2, :tag)
      midia = insert(:midia, tags: tags)

      conn =
        post(conn, "/api", %{
          "query" => @remove_midia_tags_mutation,
          "variables" => %{
            "input" => %{
              "midiaId" => midia.id,
              "tagsId" => Enum.map(tags, & &1.id)
            }
          }
        })

      assert %{"data" => %{"removeMidiaTags" => []}} = json_response(conn, 200)

      # Logo, as tags não pertencem mais a Midia
      assert {:ok, fetched} = MidiasHandler.fetch_midia(midia.id)
      assert Enum.empty?(fetched.tags)

      # Porém elas ainda existem
      assert length(MidiasHandler.list_tag()) == 2
    end
  end

  describe "adiciona tags em midia mutation" do
    setup :register_and_generate_jwt_token

    @add_midia_tags_mutation """
    mutation adicionaMidiaTags($input: AdicionaTagInput!) {
      adicionaMidiaTags(input: $input) {
        id
        etiqueta
      }
    }
    """

    test "quando a mídia não existe", %{conn: conn} do
      conn =
        post(conn, "/api", %{
          "query" => @add_midia_tags_mutation,
          "variables" => %{"input" => %{"midiaId" => "123", "tagsId" => []}}
        })

      assert %{"errors" => [error]} = json_response(conn, 200)
      assert error["code"] == "not_found"
      assert error["status_code"] == 404
    end

    test "quando nenhuma tag é adicionada", %{conn: conn} do
      midia = insert(:midia)

      assert Enum.empty?(midia.tags)

      conn =
        post(conn, "/api", %{
          "query" => @add_midia_tags_mutation,
          "variables" => %{"input" => %{"midiaId" => midia.id, "tagsId" => []}}
        })

      assert %{"data" => %{"adicionaMidiaTags" => []}} = json_response(conn, 200)
    end

    test "quando a tag não existe", %{conn: conn} do
      midia = insert(:midia, tags: [])

      conn =
        post(conn, "/api", %{
          "query" => @add_midia_tags_mutation,
          "variables" => %{"input" => %{"midiaId" => midia.id, "tagsId" => ["123"]}}
        })

      assert %{"data" => %{"adicionaMidiaTags" => []}} = json_response(conn, 200)
    end

    test "quando as tags existem", %{conn: conn} do
      tags = insert_list(2, :tag)
      midia = insert(:midia, tags: [])

      conn =
        post(conn, "/api", %{
          "query" => @add_midia_tags_mutation,
          "variables" => %{
            "input" => %{
              "midiaId" => midia.id,
              "tagsId" => Enum.map(tags, & &1.id)
            }
          }
        })

      tags_result = Enum.map(tags, &%{"id" => &1.id, "etiqueta" => &1.etiqueta})
      assert %{"data" => %{"adicionaMidiaTags" => ^tags_result}} = json_response(conn, 200)

      # Logo, as tags devem ser adicionadas à Midia
      assert {:ok, fetched} = MidiasHandler.fetch_midia(midia.id)
      assert length(fetched.tags) == 2
    end
  end
end
