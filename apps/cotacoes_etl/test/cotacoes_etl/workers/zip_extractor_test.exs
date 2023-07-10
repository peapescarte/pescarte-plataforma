defmodule CotacoesETL.Workers.ZIPExtractorTest do
  use ExUnit.Case, async: false

  import Mox

  alias CotacoesETL.Workers.ZIPExtractor

  setup :verify_on_exit!
  setup :set_mox_global

  describe "extract_zip_to_path/2" do
    @zip_file_path Path.join(__DIR__, "./teste.zip")
    @dest_path "/tmp/peapescarte/test/"

    test "extrai arquivos de um zip corretamente" do
      expect(IManagePesagroHandlerMock, :extract_boletins_zip!, fn zip_path, storage_path ->
        assert zip_path == @zip_file_path
        assert storage_path == @dest_path
        ["/tmp/peapescarte/test/teste.txt"]
      end)

      assert start_supervised!(ZIPExtractor)
      assert :ok = ZIPExtractor.extract_zip_to_path(@zip_file_path, @dest_path, self())
      assert_receive {:zip_extracted, entries}, 500
      assert length(entries) == 1
    end
  end
end
