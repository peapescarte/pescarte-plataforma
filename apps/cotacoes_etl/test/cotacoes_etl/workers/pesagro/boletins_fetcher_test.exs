defmodule CotacoesETL.Workers.Pesagro.BoletinsFetcherTest do
  use ExUnit.Case, async: false

  import Mox
  import Cotacoes.Factory

  alias Cotacoes.Handlers.CotacaoHandler
  alias CotacoesETL.Schemas.Pesagro.BoletimEntry
  alias CotacoesETL.Workers.Pesagro.BoletinsFetcher

  @moduletag :integration

  setup :set_mox_from_context
  setup :verify_on_exit!

  setup tags do
    Database.DataCase.setup_sandbox(tags)
    :ok
  end

  test "fluxo buscador de boletins pesagro" do
    insert(:fonte, nome: "pesagro")

    expect(IManagePesagroIntegrationMock, :fetch_document!, fn ->
      {"html", [],
       [
         {"a", [{"href", "/home"}, {"type", "application/zip"}, {"title", "arquivo.zip"}],
          ["hello"]}
       ]}
    end)

    assert {:ok, _pid} = BoletinsFetcher.start_link()
    [boletim] = BoletinsFetcher.get_current_boletins()

    assert %BoletimEntry{} = boletim
    assert boletim.link == "https://www.pesagro.rj.gov.br/home"
    assert boletim.arquivo == "arquivo.zip"

    assert :sys.get_state(BoletinsFetcher)

    assert [cotacao] = CotacaoHandler.list_cotacao()
    refute cotacao.importada?
    assert cotacao.fonte == "pesagro"
    assert cotacao.link == "https://www.pesagro.rj.gov.br/home"
  end
end
