defmodule CotacoesETL.Logic.ZamzarLogicTest do
  use ExUnit.Case, async: true

  alias CotacoesETL.Logic.ZamzarLogic
  alias CotacoesETL.Schemas.Zamzar.Job

  describe "job_is_successful?/1" do
    test "quando um job tem sucesso, deve retornar true" do
      assert ZamzarLogic.job_is_successful?(%Job{status: :successful})
    end

    test "quando um job não tem sucesso, deve retornar false" do
      refute ZamzarLogic.job_is_successful?(%Job{status: :converting})
    end
  end
end
