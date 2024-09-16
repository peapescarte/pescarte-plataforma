defmodule PescarteWeb.EquipesController do
  use PescarteWeb, :controller

  alias Pescarte.Supabase.Storage
  alias Supabase.Storage.Bucket

  def show(conn, _params) do
    current_path = conn.request_path
    linhas_pesquisas = get_data_from_file("linhas_pesquisas.json")

    membros =
      "membros.json"
      |> get_data_from_file()
      |> get_images()

    nucleo_norte = [
      "Equipe de Campo - Campos dos Goytacazes",
      "Equipe de Campo - Quissamã",
      "Equipe de Campo - São João da Barra",
      "Equipe de Campo - São Francisco de Itabapoana"
    ]

    nucleo_sul = [
      "Equipe de Campo - Carapebus/Macaé",
      "Equipe de Campo - Rio das Ostras",
      "Equipe de Campo - Arraial do Cabo",
      "Equipe de Campo - Cabo Frio",
      "Equipe de Campo - Armação dos Búzios"
    ]

    render(conn, :show,
      linhas_pesquisas: linhas_pesquisas,
      membros: membros,
      nucleo_norte: nucleo_norte,
      nucleo_sul: nucleo_sul,
      error_message: nil,
      current_path: current_path
    )
  end

  defp get_data_from_file(file_name) do
    "equipes"
    |> Pescarte.get_static_file_path(file_name)
    |> File.read!()
    |> Jason.decode!()
  end

  defp get_images(membros) do
    Enum.into(membros, %{}, fn {nucleo, membros} ->
      {nucleo, Enum.map(membros, &update_image/1)}
    end)
  end

  defp update_image(membro) do
    Map.update(membro, "imagem", nil, &create_signed_url/1)
  end

  defp create_signed_url(file_name) do
    result =
      Storage.create_signed_url(
        %Bucket{name: "static"},
        "images/equipes/membros/#{file_name}",
        3600
      )

    case result do
      {:ok, url} -> add_storage_suffix(url)
      {:error, _reason} -> ""
    end
  end

  defp add_storage_suffix(url) do
    [protocol_and_domain, path] = String.split(url, "/object/", parts: 2)
    "#{protocol_and_domain}/storage/v1/object/#{path}"
  end
end
