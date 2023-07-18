defmodule CotacoesETL.Workers.ZIPExtractorTest do
  use ExUnit.Case, async: false

  import CotacoesETL.Handlers, only: [zip_extractor_handler: 0]
  import Mox

  alias CotacoesETL.Handlers.ZIPExtractorHandler
  alias CotacoesETL.Workers.ZIPExtractor

  setup :verify_on_exit!
  setup :set_mox_global

  describe "extract_zip_to_path/2" do
    @zip_file_path Path.join(__DIR__, "mock.zip")
    @dest_path "/tmp/peapescarte/test/"

    test "extrai arquivos de um zip corretamente" do
      assert start_supervised!(ZIPExtractor)

      expect(IManageZIPExtractorHandlerMock, :trigger_extract_zip_to_path, fn source,
                                                                              dest,
                                                                              caller ->
        ZIPExtractorHandler.trigger_extract_zip_to_path(source, dest, caller)
      end)

      expect(IManageZIPExtractorHandlerMock, :extract_zip_to!, fn zip_path, storage_path ->
        assert zip_path == @zip_file_path
        assert storage_path == @dest_path
        ["/tmp/peapescarte/test/mock.txt"]
      end)

      assert :ok =
               zip_extractor_handler().trigger_extract_zip_to_path(
                 @zip_file_path,
                 @dest_path,
                 self()
               )

      assert_receive {:zip_extracted, entries}, 500
      assert length(entries) == 1
    end
  end
end
