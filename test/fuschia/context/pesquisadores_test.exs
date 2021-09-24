defmodule Fuschia.Context.PesquisadoresTest do
  use Fuschia.DataCase, async: true

  import Fuschia.Factory

  alias Fuschia.Context.Pesquisadores
  alias Fuschia.Entities.Pesquisador

  describe "list/1" do
    test "return all pesquisadores in database" do
      pesquisador =
        :pesquisador
        |> insert()
        |> Pesquisadores.preload_all()

      assert [pesquisador] == Pesquisadores.list()
    end
  end

  describe "one/1" do
    test "when id is valid, returns a pesquisador" do
      pesquisador =
        :pesquisador
        |> insert()
        |> Pesquisadores.preload_all()

      assert pesquisador == Pesquisadores.one(pesquisador.usuario_cpf)
    end

    test "when id is invalid, returns nil" do
      assert is_nil(Pesquisadores.one(""))
    end
  end

  describe "list_by_orientador/1" do
    test "return all pesquisadores in database with orientador of a cpf" do
      orientador = insert(:pesquisador)

      pesquisador =
        :pesquisador
        |> insert(orientador_cpf: orientador.usuario_cpf)
        |> Pesquisadores.preload_all()

      assert [pesquisador] == Pesquisadores.list_by_orientador(pesquisador.orientador_cpf)
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
               |> Pesquisadores.create()
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pesquisadores.create(@invalid_attrs)
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
      minibiografia: "updated bio",
      usuario: %{
        nome_completo: "Eduardo Ravagnani",
        cpf: "457.458.188-02",
        data_nascimento: ~D[2001-06-28],
        contato: %{
          endereco: "Av Teste, Rua Teste, numero 100",
          email: "updated_teste@exemplo.com",
          celular: "(22)12345-6769"
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

    test "when all params are valid, updates a pesquisador", %{campus_nome: campus_nome} do
      assert {:ok, pesquisador} =
               @valid_attrs
               |> Map.put(:campus_nome, campus_nome)
               |> Pesquisadores.create()

      update_attrs = Map.put(@update_attrs, :campus_nome, campus_nome)

      assert {:ok, updated_pesquisador} =
               Pesquisadores.update(pesquisador.usuario_cpf, update_attrs)

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
               |> Pesquisadores.create()

      assert {:error, %Ecto.Changeset{}} =
               Pesquisadores.update(pesquisador.usuario_cpf, @invalid_attrs)
    end
  end

  describe "exists?/1" do
    test "when id is valid, returns true" do
      pesquisador = insert(:pesquisador)
      assert true == Pesquisadores.exists?(pesquisador.usuario_cpf)
    end

    test "when id is invalid, returns false" do
      assert false == Pesquisadores.exists?("")
    end
  end
end
