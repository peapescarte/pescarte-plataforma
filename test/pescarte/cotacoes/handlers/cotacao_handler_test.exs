defmodule Cotacoes.Handlers.CotacaoHandlerTest do
  use Pescarte.DataCase, async: true

  import Pescarte.Fixtures

  alias Pescarte.Cotacoes.Handlers.CotacaoHandler

  @moduletag :unit

  describe "is_zip_file?/1" do
    test "quando recebe uma cotacao onde o link não seja um arquivo zip" do
      cotacao = insert(:cotacao, link: "https://example.com/file.pdf", tipo: :pdf)
      refute CotacaoHandler.is_zip_file?(cotacao)
    end

    test "quando recebe uma cotacao onde o link seja um arquivo zip" do
      cotacao = insert(:cotacao, link: "https://example.com/file.zip", tipo: :zip)
      assert CotacaoHandler.is_zip_file?(cotacao)
    end
  end

  describe "fetch_cotacao_by_id" do
    test "quando um id não existe na base" do
      assert {:error, :not_found} = CotacaoHandler.fetch_cotacao_by_id("lala")
    end

    test "quando um id existe na base" do
      cotacao = insert(:cotacao)

      assert {:ok, found} = CotacaoHandler.fetch_cotacao_by_id(cotacao.id)
      assert found.id == cotacao.id
      assert found.data == cotacao.data
      assert found.link == cotacao.link
    end
  end

  describe "fetch_cotacao_by_link" do
    test "quando uma cotacao com o link não existe na base" do
      assert {:error, :not_found} = CotacaoHandler.fetch_cotacao_by_link("lala")
    end

    test "quando uma cotacao com o link existe na base" do
      cotacao = insert(:cotacao)

      assert {:ok, found} = CotacaoHandler.fetch_cotacao_by_link(cotacao.link)
      assert found.id == cotacao.id
      assert found.data == cotacao.data
      assert found.link == cotacao.link
    end
  end

  describe "get_cotacao_base_file_name/1" do
    test "deve retornar o nome base do arquivo de um cotacao" do
      cotacao = insert(:cotacao, link: "https://example.com/file.pdf")

      assert "file.pdf" == CotacaoHandler.get_cotacao_file_base_name(cotacao)
    end
  end

  describe "insert_cotacao_pesagro/2" do
    test "deve inserir corretamente uma cotacao com a fonte pesagro" do
      insert(:fonte, nome: "pesagro")

      link = "https://example.com/file.pdf"
      today = Date.utc_today()

      assert {:ok, cotacao} = CotacaoHandler.insert_cotacao_pesagro(link, today)
      assert cotacao.link == link
      assert cotacao.data == today
      assert cotacao.fonte == "pesagro"
    end
  end

  describe "list_cotacao/0" do
    test "quando não há cotações" do
      assert Enum.empty?(CotacaoHandler.list_cotacao())
    end

    test "quando há contações" do
      cotacao = insert(:cotacao)

      assert [listed] = CotacaoHandler.list_cotacao()
      assert listed.id == cotacao.id
      assert listed.data == cotacao.data
      assert listed.link == cotacao.link
    end
  end

  describe "set_cotacao_downloaded/1" do
    test "deve atualizar e retornar uma cotacao com o campo baixada? como true" do
      cotacao = insert(:cotacao, baixada?: false)

      assert {:ok, updated} = CotacaoHandler.set_cotacao_downloaded(cotacao)
      assert updated.baixada?
      assert updated.id == cotacao.id
      assert updated.data == cotacao.data
      assert updated.link == cotacao.link

      assert {:ok, found} = CotacaoHandler.fetch_cotacao_by_id(cotacao.id)
      assert found.baixada?
      assert found.id == cotacao.id
      assert found.data == cotacao.data
      assert found.link == cotacao.link
    end
  end
end
