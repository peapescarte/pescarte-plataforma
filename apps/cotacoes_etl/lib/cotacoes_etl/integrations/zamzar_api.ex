defmodule CotacoesETL.Integrations.ZamzarAPI do
  use Tesla

  alias CotacoesETL.Integrations.IManageZamzarIntegration
  alias CotacoesETL.Schemas.Zamzar.File, as: FileEntry
  alias CotacoesETL.Schemas.Zamzar.Job
  alias Tesla.Multipart

  @behaviour IManageZamzarIntegration

  plug(Tesla.Middleware.BaseUrl, "https://api.zamzar.com/v1")
  plug(Tesla.Middleware.BasicAuth, username: zamzar_api_key(), password: "")
  # Ninguém pode me deter!
  plug(Tesla.Middleware.FormUrlencoded, encode: &URI.encode_query/1, decode: &Jason.decode/1)
  plug(Tesla.Middleware.FollowRedirects, max_redirects: 2)

  @impl true
  def start_job!(source_path, target_format) do
    multipart =
      Multipart.new()
      |> Multipart.add_content_type_param("charset=utf-8")
      |> Multipart.add_field("target_format", target_format)
      |> Multipart.add_file(source_path)

    "/jobs"
    |> post!(multipart)
    |> Map.fetch!(:body)
    |> Job.changeset()
  end

  @impl true
  def retrieve_job!(job_id) do
    "/jobs/#{job_id}"
    |> get!()
    |> Map.fetch!(:body)
    |> Job.changeset()
  end

  @impl true
  def download_converted_file!(file_id, target_path) do
    file_content =
      "/files/#{file_id}/content"
      |> get!()
      |> Map.fetch!(:body)

    File.write!(target_path, file_content)

    metadata = retrieve_file_info!(file_id)

    FileEntry.changeset(metadata, %{path: target_path})
  end

  @impl true
  def retrieve_file_info!(file_id) do
    "/files/#{file_id}"
    |> get!()
    |> Map.fetch!(:body)
    |> FileEntry.changeset()
  end

  defp zamzar_api_key do
    Application.get_env(:cotacoes_etl, :zamzar_api_key)
  end
end
