defmodule Cotacoes.RepositoryTest do
  use Database.DataCase, async: true

  import Cotacoes.Factory

  alias Cotacoes.Models.Cotacao
  alias Cotacoes.Repository

  @moduletag :unit

  test "find_all_cotacao_by_not_ingested/0 retorna todas as cotacoes onde importada? é false" do
    insert(:cotacao, importada?: false)
    insert(:cotacao, importada?: true, data: ~D[2023-06-07])
    found = Repository.find_all_cotacao_by_not_ingested()

    assert length(found) == 1
    assert Enum.all?(found, &(not &1.importada?))
  end

  test "insert_all_cotacao/1 insere todas as cotacoes fornecidas" do
    attrs = fixture(:cotacao)

    assert :ok = Repository.insert_all_cotacao([attrs])
    assert [inserted] = Repository.list_cotacao()

    assert inserted.fonte == attrs.fonte
    assert inserted.link == attrs.link
    assert inserted.data == attrs.data
  end

  test "list_cotacao/0 retorna todas as cotacoes" do
    cotacao = insert(:cotacao)
    [listed] = Repository.list_cotacao()

    assert ^listed = cotacao
  end

  test "update_all_cotacao/1 atualiza todas as cotacoes fornecidas" do
    cotacao = insert(:cotacao, importada?: false)
    refute cotacao.importada?

    assert {:ok, [%Cotacao{} = updated]} =
             Repository.update_all_cotacao([cotacao], importada?: true)

    assert updated.fonte == cotacao.fonte
    assert updated.link == cotacao.link
    assert updated.data == cotacao.data
    assert updated.importada?
  end

  test "upsert_cotacao/2 insere uma nova cotacao se ela não existe e atualiza se ela existe" do
    attrs = fixture(:cotacao)

    assert {:ok, inserted} = Repository.upsert_cotacao(attrs)
    assert inserted.fonte == attrs.fonte
    refute inserted.importada?

    assert {:ok, updated} = Repository.upsert_cotacao(inserted, %{importada?: true})
    assert updated.fonte == attrs.fonte
    assert updated.importada?
  end

  test "upsert_cotacao_pescado/2 insere uma nova cotacao de pescado se ela não existe e atualiza se ela existe" do
    attrs = fixture(:cotacao_pescado)

    assert {:ok, inserted} = Repository.upsert_cotacao_pescado(attrs)
    assert inserted.preco_medio == attrs.preco_medio

    assert {:ok, updated} = Repository.upsert_cotacao_pescado(inserted, %{preco_medio: 500})
    assert updated.preco_medio == 500
  end

  test "insert_all_pescado/1 insere todos os pescados fornecidos" do
    attrs = fixture(:pescado)
    assert :ok = Repository.insert_all_pescado([attrs])
    assert [inserted] = Repository.list_pescado()
    assert inserted.codigo == attrs.codigo
  end

  test "list_pescado/0 retorna todos os pescados" do
    insert_list(2, :pescado)
    found = Repository.list_pescado()

    assert length(found) == 2
  end

  test "upsert_pescado/2 insere um novo pescado se ele não existe e atualiza se ele existe" do
    attrs = fixture(:pescado)

    assert {:ok, inserted} = Repository.upsert_pescado(attrs)
    assert inserted.codigo == attrs.codigo

    assert {:ok, updated} = Repository.upsert_pescado(inserted, %{codigo: "codigo"})
    assert updated.codigo == "codigo"
  end
end
