defmodule CotacoesETL.Logic.ZamzarLogic do
  alias CotacoesETL.Schemas.Zamzar.Job

  def job_is_successful?(%Job{} = job), do: job.status == :successful
end
