defmodule CotacoesETL.Integrations.IManageZamzarIntegration do
  alias CotacoesETL.Schemas.Zamzar.Job
  alias CotacoesETL.Schemas.Zamzar.File, as: FileEntry

  @callback start_job!(source_path, target_format) :: Job.t()
            when source_path: Path.t(),
                 target_format: String.t()

  @callback retrieve_job!(job_id) :: Job.t()
            when job_id: integer

  @callback download_converted_file!(file_id, target_path) :: binary
            when file_id: integer,
                 target_path: Path.t()

  @callback retrieve_file_info!(file_id) :: FileEntry.t()
            when file_id: integer
end
