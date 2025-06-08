defmodule Pescarte.Storage do
  @moduledoc "Módulo que centraliza operações de gerenciamento de arquivos"

  # bucket padrão onde as imagens da parte pública são
  # guardadas de forma comprimida, geralmente em formato webp
  @public_image_bucket "static"
  @public_image_folder "reduced_images"

  @one_year :timer.hours(24) * 365

  @doc """
  Recupera a URL de uma imagem guardada no Storage (atualmente Supabase),
  para renderizar ela na parte pública da plataforma.

  ## Params

  - `path`: O caminho até a imagem a ser renderizada, a desconsiderar o bucket, por exemplo, se o caminho no Supabase Storage é `reduced_images/aplicativos/card_censo.webp` então o argumento dessa função será `aplicativos/card_censo.webp`.
  - `expires_in`: Tempo de expiração da URL, opcional, valor padrão de 1 ano.
  - `opts`: Argumento opcional de configuração, por exemplo para usar a API de transformação de imagens da Supabase, passando a opção `:transform` onde o valor são parâmetros válidos de `Supabase.Storage.TransformOptions`
  - `bucket`: O nome do bucket a ser usado, opcional pois o valor padrão é `static`, já com a pasta `reduced_images` adicionada ao caminho.

  ## Examples

      iex> Pescarte.Storage.get_public_area_image_url("aplicativos/card_censo.webp")
      {:ok, "https://supabase-url"}

      iex> Pescarte.Storage.get_public_area_image_url("arquivo-nao-existe")
      {:error, :file_not_found}
  """
  def get_public_area_image_url(
        path,
        expires_in \\ @one_year,
        opts \\ [],
        bucket \\ @public_image_bucket
      )
      when is_binary(path) and is_binary(bucket) do
    with {:ok, client} <- Pescarte.Supabase.get_client() do
      path = Path.join(@public_image_folder, path)
      storage = Supabase.Storage.from(client, bucket)
      opts = [{:expires_in, expires_in} | opts]
      Supabase.Storage.File.create_signed_url(storage, path, opts)
    end
  end

  @appointments_data_bucket "static"
  @appointments_data_folder "agenda"

  @spec download_file(String.t(), String.t()) :: {:ok, binary} | {:error, term}
  def download_file(bucket, path)
      when is_binary(bucket) and is_binary(path) do
    with {:ok, client} <- Pescarte.Supabase.get_client(),
         storage <- Supabase.Storage.from(client, bucket),
         {:ok, %{body: body}} <- Supabase.Storage.File.download(storage, path) do
      {:ok, IO.iodata_to_binary(body)}
    end
  end

  @spec fetch_appointments_csv(String.t()) :: {:ok, binary} | {:error, term}
  def fetch_appointments_csv(filename) when is_binary(filename) do
    path = Path.join(@appointments_data_folder, filename)
    download_file(@appointments_data_bucket, path)
  end
end
