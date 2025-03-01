defmodule Pescarte.Supabase do
  use Supabase.Client, otp_app: :pescarte

  alias Supabase.Storage
  alias Supabase.Storage.File

  @spec retrieve_url_from_storage(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def retrieve_url_from_storage(path) do
    bucket_id = "static"

    with {:ok, client} <- get_client(),
         {:ok, url} <-
           File.create_signed_url(%Storage{bucket_id: bucket_id, client: client}, path,
             expires_in: 300_000
           ) do
      {:ok, url}
    else
      {:error, _} -> {:error, "Failed to retrieve URL"}
    end
  end
end
