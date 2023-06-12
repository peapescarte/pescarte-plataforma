defmodule PescarteWeb.GraphQL.SchemaTest do
  use PescarteWeb.ConnCase, async: true

  import Pescarte.Factory

  alias Pescarte.Domains.ModuloPesquisa.Handlers
  alias Pescarte.Domains.ModuloPesquisa.Models.Midia.Tag
  alias Pescarte.Repo

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
        post(conn, "/api", %{
          "query" => @login_mutation,
          "variables" => %{"input" => %{"cpf" => "123", "senha" => "123"}}
        })

      assert %{"errors" => [error]} = json_response(conn, 200)

      assert error["code"] == "not_found"
      assert error["status_code"] == 404
    end

    test "quando cpf/senha são válidos", %{conn: conn} do
      user = insert(:user)

      conn =
        post(conn, "/api", %{
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
      conn = post(conn, "/api", %{"query" => @simple_list_query})

      assert %{"errors" => [error]} = json_response(conn, 200)

      assert error["code"] == "unauthenticated"
      assert error["status_code"] == 401
    end
  end

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
      conn = post(conn, "/api", %{"query" => @list_user_query})

      assert %{"data" => %{"listarUsuarios" => users}} = json_response(conn, 200)
      assert length(users) == 1
    end

    test "quando há um usuário", %{conn: conn} do
      user = insert(:user)
      conn = post(conn, "/api", %{"query" => @list_user_query})

      assert %{"data" => %{"listarUsuarios" => [_, listed]}} = json_response(conn, 200)
      assert listed["cpf"] == user.cpf
    end
  end

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
      assert listed["id"] == categoria.id_publico
      assert listed["nome"] == categoria.nome
    end

    test "quando há categoria e nenhuma tag, recuperar tags vazia", %{conn: conn} do
      categoria = insert(:categoria)
      conn = post(conn, "/api", %{"query" => @list_categorias_query})

      assert %{"data" => %{"listarCategorias" => [listed]}} = json_response(conn, 200)
      assert listed["id"] == categoria.id_publico
      assert listed["nome"] == categoria.nome
      assert Enum.empty?(listed["tags"])
    end

    test "quando há categoria e há tags, recuperar tags", %{conn: conn} do
      %{categoria: categoria} = tag = Repo.preload(insert(:tag), [:categoria])
      conn = post(conn, "/api", %{"query" => @list_categorias_query})

      assert %{"data" => %{"listarCategorias" => [listed]}} = json_response(conn, 200)
      assert listed["id"] == categoria.id_publico
      assert listed["nome"] == categoria.nome

      [tag_listed] = listed["tags"]
      assert tag_listed["id"] == tag.id_publico
      assert tag_listed["etiqueta"] == tag.etiqueta
      assert tag_listed["categoria"]["id"] == categoria.id_publico
    end
  end

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
      conn = post(conn, "/api", %{"query" => @list_tags_query})

      assert %{"data" => %{"listarTags" => []}} = json_response(conn, 200)
    end

    test "quando há tag", %{conn: conn} do
      %{categoria: categoria} = tag = Repo.preload(insert(:tag), :categoria)
      conn = post(conn, "/api", %{"query" => @list_tags_query})

      assert %{"data" => %{"listarTags" => [listed]}} = json_response(conn, 200)
      assert listed["id"] == tag.id_publico
      assert listed["etiqueta"] == tag.etiqueta
      assert listed["categoria"]["id"] == categoria.id_publico
    end
  end

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
      %{tags: [tag]} = midia = Repo.preload(insert(:midia, tags: [insert(:tag)]), [:autor, :tags])
      %{categoria: categoria} = Repo.preload(tag, :categoria)

      conn = post(conn, "/api", %{"query" => @list_midias_query})

      assert %{"data" => %{"listarMidias" => [listed]}} = json_response(conn, 200)
      assert listed["id"] == midia.id_publico
      assert listed["nomeArquivo"] == midia.nome_arquivo
      assert listed["autor"]["id"] == midia.autor.id_publico

      [tag_listed] = listed["tags"]
      assert tag_listed["id"] == tag.id_publico
      assert tag_listed["categoria"]["id"] == categoria.id_publico
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
      %{tags: [tag]} = midia = Repo.preload(insert(:midia, tags: [insert(:tag)]), [:autor, :tags])
      %{categoria: categoria} = Repo.preload(tag, :categoria)

      conn =
        post(conn, "/api", %{
          "query" => @get_midia_query,
          "variables" => %{"id" => midia.id_publico}
        })

      assert %{"data" => %{"buscarMidia" => fetched}} = json_response(conn, 200)
      assert fetched["id"] == midia.id_publico
      assert fetched["nomeArquivo"] == midia.nome_arquivo
      assert fetched["autor"]["id"] == midia.autor.id_publico

      [tag_listed] = fetched["tags"]
      assert tag_listed["id"] == tag.id_publico
      assert tag_listed["categoria"]["id"] == categoria.id_publico
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
        post(conn, "/api", %{
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
        post(conn, "/api", %{
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
        post(conn, "/api", %{
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
        post(conn, "/api", %{
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
        post(conn, "/api", %{
          "query" => @create_tags_mutation,
          "variables" => %{"input" => params}
        })

      assert %{"data" => %{"criarTags" => created}} = json_response(conn, 200)
      assert length(created) == 2
      assert Repo.aggregate(Tag, :count) == 2
    end

    test "quando os parâmetros de apenas uma tag são inváidos, ao tentar criar vários, 2 vezes",
         %{conn: conn} do
      categoria = insert(:categoria)

      params = [
        %{"etiqueta" => "sol", "categoriaId" => categoria.id_publico},
        %{"etiqueta" => "", "categoriaId" => categoria.id_publico}
      ]

      conn =
        post(conn, "/api", %{
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
        post(conn, "/api", %{
          "query" => @create_tags_mutation,
          "variables" => %{"input" => another_params}
        })

      assert %{"data" => %{"criarTags" => created}} = json_response(another_conn, 200)
      assert length(created) == 2
      assert Repo.aggregate(Tag, :count) == 2
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
        post(conn, "/api", %{
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
        post(conn, "/api", %{
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
      autor = insert(:user)

      params = %{
        "autorId" => autor.id_publico,
        "nomeArquivo" => "imagem.png",
        "link" => "http://localhost:4000/imagem.png",
        "tipo" => "IMAGEM",
        "dataArquivo" => "2023-02-23",
        "tags" => [
          %{
            "etiqueta" => "um_teste",
            "categoriaId" => categoria.id_publico
          },
          %{
            "etiqueta" => "outro_teste",
            "categoriaId" => categoria.id_publico
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
      assert created["autor"]["id"] == autor.id_publico
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
      midia = Repo.preload(insert(:midia), :tags)

      assert Enum.empty?(midia.tags)

      conn =
        post(conn, "/api", %{
          "query" => @remove_midia_tags_mutation,
          "variables" => %{"input" => %{"midiaId" => midia.id_publico, "tagsId" => []}}
        })

      assert %{"data" => %{"removeMidiaTags" => []}} = json_response(conn, 200)
    end

    test "quando a tag não existe", %{conn: conn} do
      midia = insert(:midia, tags: [])

      conn =
        post(conn, "/api", %{
          "query" => @remove_midia_tags_mutation,
          "variables" => %{"input" => %{"midiaId" => midia.id_publico, "tagsId" => ["123"]}}
        })

      assert %{"data" => %{"removeMidiaTags" => []}} = json_response(conn, 200)
    end

    test "quando as tags existem", %{conn: conn} do
      tags = insert_list(2, :tag)
      midia = Repo.preload(insert(:midia, tags: tags), :tags)

      assert length(midia.tags) == 2

      conn =
        post(conn, "/api", %{
          "query" => @remove_midia_tags_mutation,
          "variables" => %{
            "input" => %{
              "midiaId" => midia.id_publico,
              "tagsId" => Enum.map(tags, & &1.id_publico)
            }
          }
        })

      assert %{"data" => %{"removeMidiaTags" => []}} = json_response(conn, 200)

      # Logo, as tags não pertencem mais a Midia
      assert {:ok, fetched} = Handlers.Midias.fetch_midia(midia.id_publico)
      assert Enum.empty?(fetched.tags)

      # Porém elas ainda existem
      assert length(Handlers.Midias.list_tag()) == 2
    end
  end
end
