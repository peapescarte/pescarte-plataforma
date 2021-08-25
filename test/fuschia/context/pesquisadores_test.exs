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
      pesquisador =
        :pesquisador
        |> insert()
        |> Pesquisadores.preload_all()

      assert [pesquisador] == Pesquisadores.list_by_orientador(pesquisador.orientador_cpf)
    end
  end

  describe "create/1" do
    @valid_attrs %{
      usuario_cpf: "264.722.590-70",
      minibiografia: "minibibliografia aaa",
      tipo_bolsa: "ic",
      link_lattes: "www.lattes",
      campus: %{
        nome: "Campus Estadual do Norte Fluminence Darcy Ribeiro",
        cidade: %{municipio: "Campos dos Goytacazes"}
      },
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
      usuario_cpf: nil,
      minibiografia: nil,
      tipo_bolsa: nil,
      link_lattes: nil,
      orientador: nil,
      campus: nil,
      usuario: nil,
      orientandos: nil
    }

    test "when all params are valid, creates an admin pesquisador" do
      assert {:ok, %Pesquisador{}} = Pesquisadores.create(@valid_attrs)
    end

    test "when params are invalid, returns an error changeset" do
      assert {:error, %Ecto.Changeset{}} = Pesquisadores.create(@invalid_attrs)
    end
  end

  describe "update/1" do
    @valid_attrs %{
      usuario_cpf: "264.722.590-70",
      minibiografia: "minibibliografia aaa",
      tipo_bolsa: "ic",
      link_lattes: "www.lattes",
      campus: %{
        nome: "Campus Estadual do Norte Fluminence Darcy Ribeiro",
        cidade: %{municipio: "Campos dos Goytacazes"}
      },
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
      usuario_cpf: "457.458.188-02",
      tipo_bolsa: "pesquisador",
      link_lattes: "www.lattes/novo_link",
      usuario: %{
        nome_completo: "Eduardo Ravagnani",
        cpf: "457.458.188-02",
        data_nascimento: ~D[2001-06-28],
        contato: %{
          endereco: "Av Teste, Rua Teste, numero 100",
          email: "teste@exemplo.com",
          celular: "(22)12345-6769"
        },
        password: "Teste1234",
        password_confirmation: "Teste1234"
      }
    }

    @invalid_attrs %{
      cpf: nil,
      minibiografia: nil,
      tipo_bolsa: nil,
      link_lattes: nil,
      orientador: nil,
      campus: nil,
      usuario: nil,
      orientandos: nil
    }

    test "when all params are valid, updates a pesquisador" do
      assert {:ok, pesquisador} = Pesquisadores.create(@valid_attrs)

      assert {:ok, updated_pesquisador} =
               Pesquisadores.update(pesquisador.usuario_cpf, @update_attrs)

      for key <- Map.keys(@update_attrs) do
        if key == :contato do
          contato = Map.get(updated_pesquisador, key)
          contato_attrs = Map.get(@update_attrs, key)
          assert contato.email == contato_attrs.email
          assert contato.endereco == contato_attrs.endereco
          assert contato.celular == contato_attrs.celular
        else
          assert Map.get(updated_pesquisador, key) == Map.get(@update_attrs, key)
        end
      end
    end

    test "when params are invalid, returns an error changeset" do
      assert {:ok, pesquisador} = Pesquisadores.create(@valid_attrs)

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
