defmodule CotacoesETL.Integrations.ZamzarAPITest do
  use ExUnit.Case, async: true

  alias CotacoesETL.Schemas.Zamzar.File, as: FileEntry
  alias CotacoesETL.Schemas.Zamzar.Job

  import CotacoesETL.Integrations, only: [zamzar_api: 0]
  import Mox

  setup :verify_on_exit!

  @moduletag :integration

  @job_mock %Job{
    id: 15,
    key: "d62630b3b08643d2a76acaa34f453f60c8439252",
    status: :initialising,
    sandbox: true,
    created_at: ~N[2013-10-27T13:41:00Z],
    finished_at: nil,
    source_file: %FileEntry{id: 2, name: "portrait.gif", size: 90_571},
    target_files: [],
    target_format: "png",
    credit_cost: 1
  }

  describe "start_job!/2" do
    test "quando recebe um caminho de arquivo existente e um formato, deve retorna um Job" do
      expect(IManageZamzarIntegrationMock, :start_job!, fn source, format ->
        assert is_binary(source)
        assert is_binary(format)

        @job_mock
      end)

      assert %Job{} = zamzar_api().start_job!("/tmp/portrait.gif", "pdf")
    end
  end

  describe "retrieve_job!/1" do
    expect(IManageZamzarIntegrationMock, :retrieve_job!, fn job_id ->
      assert is_integer(job_id)

      %{@job_mock | target_files: [%FileEntry{id: 3, name: "portrait.pdf"}]}
    end)

    assert %Job{} = job = zamzar_api().retrieve_job!(@job_mock.id)
    assert job.id == @job_mock.id
    refute Enum.empty?(job.target_files)
  end

  describe "download_converted_file!/2" do
    expect(IManageZamzarIntegrationMock, :download_converted_file!, fn file_id, target_path ->
      assert is_integer(file_id)
      File.write!(target_path, "teste")

      %FileEntry{id: 4, name: "portrait.pdf", path: target_path}
    end)

    file = %FileEntry{id: 4, name: "portrait.gif"}
    assert %FileEntry{} = file = zamzar_api().download_converted_file!(file.id, "/tmp/teste.pdf")
    assert file.path == "/tmp/teste.pdf"
    assert file.name == "portrait.pdf"
    assert File.exists?("/tmp/teste.pdf")

    File.rm!("/tmp/teste.pdf")
  end
end
