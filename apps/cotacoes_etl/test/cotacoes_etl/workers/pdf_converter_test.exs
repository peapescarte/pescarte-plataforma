defmodule CotacoesETL.Workers.PDFConverterTest do
  use ExUnit.Case, async: false

  import CotacoesETL.Handlers, only: [pdf_converter_handler: 0]
  import Mox

  alias CotacoesETL.Handlers.PDFConverterHandler
  alias CotacoesETL.Workers.PDFConverter

  @moduletag :integration

  setup :verify_on_exit!
  setup :set_mox_global

  describe "convert_pdf_to_txt/2" do
    @pdf_file_path Path.join(__DIR__, "mock.pdf")
    @dest_file_path "/tmp/peapescarte/test"
    @txt_file_path "/tmp/peapescarte/test/mock.txt"

    test "converte com successo um arquivo PDF para TXT" do
      assert start_supervised!(PDFConverter)

      expect(IManagePDFConverterHandlerMock, :trigger_pdf_convertion_to_txt, fn source,
                                                                                dest,
                                                                                caller ->
        PDFConverterHandler.trigger_pdf_convertion_to_txt(source, dest, caller)
      end)

      expect(IManagePDFConverterHandlerMock, :convert_to_txt!, fn _file_path ->
        "hello, world!"
      end)

      assert :ok =
               pdf_converter_handler().trigger_pdf_convertion_to_txt(
                 @pdf_file_path,
                 @dest_file_path,
                 self()
               )

      assert_receive {:pdf_converted, path}, 500
      assert path == @txt_file_path
    end
  end
end
