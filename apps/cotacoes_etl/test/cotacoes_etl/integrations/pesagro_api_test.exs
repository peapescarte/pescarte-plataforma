defmodule CotacoesETL.Integrations.PesagroAPITest do
  use ExUnit.Case, async: true

  import Mox

  alias CotacoesETL.Integrations
  alias CotacoesETL.Integrations.PesagroAPI
  alias CotacoesETL.Schemas.Pesagro.BoletimEntry

  @moduletag :integration

  setup :verify_on_exit!

  test "fetch_document!/0" do
    expect(IManagePesagroIntegrationMock, :fetch_document!, fn ->
      {"html", [],
       [
         {"a", [{"href", "/home"}, {"type", "application/zip"}, {"title", "arquivo.zip"}],
          ["hello"]}
       ]}
    end)

    assert document = Integrations.pesagro_api().fetch_document!()
    [boletim] = PesagroAPI.fetch_all_boletim_links(document)

    assert %BoletimEntry{} = boletim
    assert boletim.link == "https://www.pesagro.rj.gov.br/home"
    assert boletim.arquivo == "arquivo.zip"
  end
end
