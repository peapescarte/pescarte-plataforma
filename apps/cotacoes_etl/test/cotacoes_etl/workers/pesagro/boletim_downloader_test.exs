defmodule CotacoesETL.Workers.Pesagro.BoletimDownloaderTest do
  use Database.DataCase, async: false

  import Cotacoes.Factory
  import Mox

  alias Cotacoes.Models.Cotacao
  alias CotacoesETL.Schemas.Pesagro.BoletimEntry
  alias CotacoesETL.Workers.PDFConverter
  alias CotacoesETL.Workers.Pesagro.BoletimDownloader
  alias CotacoesETL.Workers.ZIPExtractor

  @moduletag :integration

  setup :verify_on_exit!
  setup :set_mox_global

  describe "fluxo de download de um boletim e conversão do mesmo para TXT" do
    @pdf_file_path Path.join(__DIR__, "mock_pdf.pdf")
    @pdf_converted_content "Hello, world!"
    @boletim_pdf_entry %BoletimEntry{
      tipo: :pdf,
      link: "https://example.com/pesagro/mock_pdf.pdf",
      arquivo: "mock_pdf.pdf"
    }

    @boletim_zip_entry %BoletimEntry{
      tipo: :pdf,
      link: "https://example.com/pesagro/teste.zip",
      arquivo: "teste.zip"
    }

    test "quando recebe uma mensagem que um novo boletim PDF foi encontrado" do
      assert %Cotacao{link: cotacao_link} = insert(:cotacao, link: @boletim_pdf_entry.link)

      expect(IManagePesagroHandlerMock, :download_boletim_from_pesagro!, fn dest_path, cotacao ->
        assert cotacao.link == @boletim_pdf_entry.link
        assert cotacao.link == cotacao_link
        assert dest_path == "/tmp/peapescarte/cotacoes/pesagro/"
        @pdf_file_path
      end)

      expect(IManagePesagroHandlerMock, :is_zip_file?, fn boletim ->
        assert boletim.link == @boletim_pdf_entry.link
        assert boletim.tipo == @boletim_pdf_entry.tipo
        false
      end)

      expect(IManagePDFConverterMock, :convert_pdf_to_txt, fn source, dest, _caller ->
        GenServer.cast(
          PDFConverter,
          {:convert, caller: self(), from: source, to: dest, format: :txt}
        )
      end)

      expect(IManagePDFConverterMock, :convert_to_txt!, fn file_path ->
        assert file_path == @pdf_file_path
        @pdf_converted_content
      end)

      assert start_supervised!(PDFConverter)
      assert start_supervised!(BoletimDownloader)

      Process.send(BoletimDownloader, {:download, @boletim_pdf_entry}, [])
    end

    test "quando recebe uma mensagem que um novo boletim ZIP foi encontrado" do
      assert start_supervised!(PDFConverter)
      assert start_supervised!(ZIPExtractor)
      assert start_supervised!(BoletimDownloader)
      assert System.find_executable("gs")
    end
  end
end
