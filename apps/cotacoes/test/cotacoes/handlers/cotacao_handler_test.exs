defmodule Cotacoes.Handlers.CotacaoHandlerTest do
  use Database.DataCase, async: true

  import Cotacoes.Factory

  alias Cotacoes.Handlers.CotacaoHandler

  @moduletag :unit

  describe "reject_inserted_cotacoes/1" do
    test "quando não existem cotacoes" do
      cotacao = fixture(:cotacao)
      assert [^cotacao] = CotacaoHandler.reject_inserted_cotacoes([cotacao])
    end

    test "quando existem cotacoes" do
      insert(:cotacao)
      cotacao = fixture(:cotacao)
      assert [^cotacao] = CotacaoHandler.reject_inserted_cotacoes([cotacao])
    end
  end
end
