defmodule CotacoesETL.Workers.Pesagro.CotacaoConverterTest do
  use Database.DataCase, async: false

  import Cotacoes.Factory
  import Mox

  alias Cotacoes.Models.Cotacao
  alias CotacoesETL.Schemas.Zamzar.File, as: FileEntry
  alias CotacoesETL.Schemas.Zamzar.Job
  alias CotacoesETL.Workers.Pesagro.CotacaoConverter

  @moduletag :integration

  setup :set_mox_from_context
  setup :verify_on_exit!

  describe "fluxo de conversão de cotações não baixadas" do
    @test_path_pdf "/tmp/peapescarte/teste.pdf"
    # @test_path_zip "/tmp/peapescarte/teste.zip"
    # @test_path_converted "/tmp/peapescarte/teste.txt"
    # @binary_test <<72, 101, 108, 108, 111, 44, 32, 87, 111, 114, 108, 100, 33>>
    # @file_test_converted %FileEntry{id: 1, name: "teste.txt", path: @test_path_converted}
    @job_test_converting %Job{
      id: 1,
      status: :converting,
      source_file: %FileEntry{id: 1, name: "teste.pdf"}
    }

    test "happy path apenas com pdfs" do
      _cotacao = insert(:cotacao)

      # expect(IManagePesagroIntegrationMock, :download_file!, fn link ->
      #   assert is_binary(link)
      #   @binary_test
      # end)

      expect(IManagePesagroHandlerMock, :download_boletim_from_pesagro!, fn path, cot ->
        assert %Cotacao{} = cot
        assert is_binary(path)
        @test_path_pdf
      end)

      # expect(IManageZamzarHandlerMock, :upload_pesagro_pdf!, fn pdf_path, time_offset ->
      #   assert is_binary(pdf_path)
      #   assert is_integer(time_offset)
      #   @job_test_converting
      # end)

      # expect(IManageZamzarIntegrationMock, :retrieve_job!, fn job_id ->
      #   assert is_integer(job_id)
      #   %{@job_test_converting | status: :successful, target_files: [@file_test_converted]}
      # end)

      # expect(IManageZamzarHandlerMock, :download_pesagro_txt!, fn job, base_path ->
      #   assert is_binary(base_path)
      #   assert %Job{} = job
      #   @file_test_converted
      # end)

      # expect(IManageZamzarIntegrationMock, :download_converted_file!, fn file_id, target_path ->
      #   assert is_integer(file_id)
      #   assert is_binary(target_path)
      #   @file_test_converted
      # end)

      # expect(IManageZamzarIntegrationMock, :start_job!, fn source_path, format ->
      #   assert is_binary(source_path)
      #   assert is_binary(format)
      #   @job_test_converting
      # end)

      assert {:ok, _pid} = CotacaoConverter.start_link([])
      # Step 1: arquivos baixados
      assert :ok = CotacaoConverter.trigger_cotacoes_convertion()
      assert :sys.get_state(CotacaoConverter)
      # Step 2: upload dos pdf
      assert [] = :sys.get_state(CotacaoConverter)
    end

    test "happy path com zip" do
      cotacao = insert(:cotacao)

      # expect(IManagePesagroHandlerMock, :download_boletim_from_pesagro!, fn path, cot ->
      #   assert %Cotacao{} = cot
      #   assert is_binary(path)
      #   @test_path_zip
      # end)

      assert %Cotacao{} = cotacao
    end
  end
end
