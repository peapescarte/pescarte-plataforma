defmodule Fuschia.Queries.PesquisadoresTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Db
  alias Fuschia.Accounts.Pesquisador
  alias Fuschia.Queries.Pesquisadores

  @moduletag :unit

  describe "list/1" do
    test "return all pesquisadores in database" do
      insert(:pesquisador)

      pesquisador = Db.one(Pesquisadores.query())

      assert [pesquisador] == Db.list(Pesquisadores.query())
    end
  end

  describe "one/1" do
    test "when id is valid, returns a pesquisador" do
      insert(:pesquisador)

      pesquisador = Db.one(Pesquisadores.query())

      assert pesquisador == Db.get(Pesquisadores.query(), pesquisador.usuario_cpf)
    end

    test "when id is invalid, returns nil" do
      assert Pesquisadores.query() |> Db.get("") |> is_nil()
    end
  end

  describe "list_by_orientador/1" do
    test "return all pesquisadores in database with orientador of a cpf" do
      orientador = insert(:pesquisador)

      %{usuario_cpf: pesquisador_cpf} =
        insert(:pesquisador, orientador_cpf: orientador.usuario_cpf)

      pesquisador = Db.get(Pesquisadores.query(), pesquisador_cpf)

      assert [pesquisador] ==
               pesquisador.orientador_cpf |> Pesquisadores.query_by_orientador() |> Db.list()
    end
  end

  describe "create/1" do
    @valid_attrs %{
      minibiografia: "minibibliografia aaa",
      tipo_bolsa: "ic",
      link_lattes: "www.lattes",
      usuario: %{
        nome_completo: "Matheus de Souza Pessanha",
        cpf: "264.722.590-70",
        data_nascimento: ~D[2001-07-27],
        perfil: "admin",
        contato: %{
          endereco: "Av Teste, Rua Teste, numero 123",
          email: "teste@exemplo.com",
          celular: "(22)12345-6789"
        }
      }
    }

    @invalid_attrs %{
      minibiografia: nil,
      tipo_bolsa: nil,
      link_lattes: nil,
      orientador: nil,
      campus_nome: nil,
      usuario: nil,
      orientandos: nil
    }

    test "when all params are valid, creates an admin pesquisador" do
      %{nome: campus_nome} = insert(:campus)

      assert {:ok, %Pesquisador{}} =
               @valid_attrs
               |> Map.put(:campus_nome, campus_nome)
               |> then(&Db.create(Pesquisador, &1))
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Db.create(Pesquisador, @invalid_attrs)
    end
  end

  describe "update/1" do
    setup do
      %{campus_nome: insert(:campus).nome}
    end

    @valid_attrs %{
      minibiografia: "minibibliografia aaa",
      tipo_bolsa: "ic",
      link_lattes: "www.lattes.com",
      usuario: %{
        nome_completo: "Matheus de Souza Pessanha",
        cpf: "264.722.590-70",
        data_nascimento: ~D[2001-07-27],
        perfil: "admin",
        contato: %{
          endereco: "Av Teste, Rua Teste, numero 123",
          email: "teste@exemplo.com",
          celular: "(22)12345-6789"
        }
      }
    }

    @update_attrs %{
      link_lattes: "www.lattes/novo_link",
      minibiografia: "updated bio"
    }

    @invalid_attrs %{
      minibiografia: nil,
      tipo_bolsa: nil,
      link_lattes: nil,
      orientador: nil,
      campus_nome: nil,
      usuario: nil,
      orientandos: nil
    }

    test "when all params are valid, updates a pesquisador", %{campus_nome: campus_nome} do
      assert {:ok, pesquisador} =
               @valid_attrs
               |> Map.put(:campus_nome, campus_nome)
               |> then(&Db.create(Pesquisador, &1))

      update_attrs = Map.put(@update_attrs, :campus_nome, campus_nome)

      assert {:ok, updated_pesquisador} =
               Db.update(
                 Pesquisadores.query(),
                 &Pesquisador.changeset/2,
                 pesquisador.usuario_cpf,
                 update_attrs,
                 Pesquisadores.relationships()
               )

      for key <- Map.keys(@update_attrs) do
        cond do
          key == :contato ->
            contato = Map.get(updated_pesquisador, key)
            contato_attrs = Map.get(@update_attrs, key)
            assert contato.email == contato_attrs.email
            assert contato.endereco == contato_attrs.endereco
            assert contato.celular == contato_attrs.celular

          key == :usuario ->
            usuario = Map.get(updated_pesquisador, key)
            usuario_attrs = Map.get(@update_attrs, key)
            assert usuario.cpf == usuario_attrs.cpf
            assert usuario.nome_completo == usuario_attrs.nome_completo
            assert usuario.data_nascimento == usuario_attrs.data_nascimento

          true ->
            assert Map.get(updated_pesquisador, key) == Map.get(@update_attrs, key)
        end
      end
    end

    test "when params are invalid, returns an error changeset", %{campus_nome: campus_nome} do
      assert {:ok, pesquisador} =
               @valid_attrs
               |> Map.put(:campus_nome, campus_nome)
               |> then(&Db.create(Pesquisador, &1))

      assert {:error, %Ecto.Changeset{}} =
               Db.update(
                 Pesquisadores.query(),
                 &Pesquisador.changeset/2,
                 pesquisador.usuario_cpf,
                 @invalid_attrs,
                 Pesquisadores.relationships()
               )
    end
  end

  describe "exists?/1" do
    test "when id is valid, returns true" do
      pesquisador = insert(:pesquisador)

      assert true == pesquisador.usuario_cpf |> Pesquisadores.query_exists() |> Db.exists?()
    end

    test "when id is invalid, returns false" do
      assert false == "" |> Pesquisadores.query_exists() |> Db.exists?()
    end
  end
end
